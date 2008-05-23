require File.dirname(__FILE__) + '/test_helper'

class Devpay::LicenseServiceTest < Test::Unit::TestCase
  include LicenseServiceTestHelper
  
  context "The License Service" do
    
    setup do
      @ls = Devpay::LicenseService.new
    end
    
    should "raise an UserNotSubscribed error" do
      Net::HTTP.any_instance.stubs(:request).returns(unsuccessful_http_response('UserNotSubscribed'))
      assert_raise(Devpay::Errors::LicenseService::UserNotSubscribed) do
        @ls.activate_hosted_product(
          TEST_ACTIVATION_KEY,
          TEST_PRODUCT_TOKEN,
          TEST_ACCESS_KEY_ID,
          TEST_SECRET_ACCESS_KEY
        )
      end
    end
    
    context "when activating a hosted product" do
      
      setup do
        @ls.stubs(:make_request).returns(activate_hosted_product_success)
      end
      
      should "return an ActivationResponse" do
        assert_kind_of(
          Devpay::ActivationResponse, 
          @ls.activate_hosted_product(
            TEST_ACTIVATION_KEY,
            TEST_PRODUCT_TOKEN,
            TEST_ACCESS_KEY_ID,
            TEST_SECRET_ACCESS_KEY
          )
        )
      end
      
      context "the ActivationResponse" do
        
        setup do
          @response = @ls.activate_hosted_product(
            TEST_ACTIVATION_KEY,
            TEST_PRODUCT_TOKEN,
            TEST_ACCESS_KEY_ID,
            TEST_SECRET_ACCESS_KEY
          )
        end
        
        should "contain the user token" do
          assert_equal '{UserToken}thisismytestusertokenthisismytestusertoken', @response.user_token
        end
        
        should "contain the persistent identifier" do
          assert_equal 'TESTPERSISTENTIDENTIFIER', @response.persistent_identifier
        end
        
      end
      
    end
    
    context "when getting active subscriptions" do
      
      setup do
        @ls.stubs(:make_request).returns(get_active_subscriptions_success)
      end
      
      should "return an Array of Strings" do
        results = @ls.get_active_subscriptions(
          TEST_PID,
          TEST_ACCESS_KEY_ID,
          TEST_SECRET_ACCESS_KEY
        )
        assert_kind_of Array, results
        assert results.all? { |a| a.kind_of?(String) }
      end
      
      should "contain expected number of codes" do
        results = @ls.get_active_subscriptions(
          TEST_PID,
          TEST_ACCESS_KEY_ID,
          TEST_SECRET_ACCESS_KEY
        )
        assert_equal 2, results.size
      end
      
      should "contain expected codes" do
        results = @ls.get_active_subscriptions(
          TEST_PID,
          TEST_ACCESS_KEY_ID,
          TEST_SECRET_ACCESS_KEY
        )
        %w(6883959E 774F4FF8).each do |code|
          assert results.include?(code)
        end
      end
      
    end
    
    context "when verifying a product subscription" do
      
      setup do
        @ls.stubs(:make_request).returns(verify_product_subscription_response)
      end
      
      should "be true" do
        assert @ls.verify_product_subscription(
          TEST_PID,
          TEST_PRODUCT_CODE,
          TEST_ACCESS_KEY_ID,
          TEST_SECRET_ACCESS_KEY
        )
      end
      
      should "be false" do
        @ls.stubs(:make_request).returns(verify_product_subscription_response('false'))
        assert !@ls.verify_product_subscription(
          TEST_PID,
          TEST_PRODUCT_CODE,
          TEST_ACCESS_KEY_ID,
          TEST_SECRET_ACCESS_KEY
        )
      end
      
    end
    
    context "when Net::HTTP times out" do
      
      setup do
        Net::HTTP.any_instance.stubs(:start).
          with(any_parameters).
          raises(Timeout::Error, 'Timed out')
      end
      
      should "raise a LicenseService::TimeoutError" do
        assert_raise(Devpay::Errors::LicenseService::TimeoutError) do
          @ls.activate_hosted_product(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN, TEST_ACCESS_KEY_ID, TEST_SECRET_ACCESS_KEY)
        end
      end
      
    end
    
  end
  
end