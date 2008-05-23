require File.dirname(__FILE__) + '/test_helper'
require 'net/http'

class LicenseServiceTest < Test::Unit::TestCase
  include LicenseServiceTestHelper
  
  context "The License Service" do
    
    setup do
      @ls = Devpay::LicenseService.new
    end
    
    should "raise an UserNotSubscribed error" do
      Net::HTTP.any_instance.expects(:get2).returns(mock_http_response('Net::HTTPForbidden', '403', 'Forbidden') { erred_response_body('UserNotSubscribed') })
      
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
        Net::HTTP.any_instance.stubs(:get2).
          returns(mock_http_response { activate_hosted_product_response_body })
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
        Net::HTTP.any_instance.stubs(:get2).
          returns(mock_http_response { get_active_subscriptions_response_body })
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
      
      should "contain the correct number of product codes" do
        results = @ls.get_active_subscriptions(
          TEST_PID,
          TEST_ACCESS_KEY_ID,
          TEST_SECRET_ACCESS_KEY
        )
        assert_equal 2, results.size
      end
      
      should "contain the expected product codes" do
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
      
      context "an active subscription" do
        
        setup do
          Net::HTTP.any_instance.stubs(:get2).
            returns(mock_http_response { verify_product_subscription_response_body(true) })
        end
        
        should "return true" do
          assert @ls.verify_product_subscription(
            TEST_PID,
            TEST_PRODUCT_CODE,
            TEST_ACCESS_KEY_ID,
            TEST_SECRET_ACCESS_KEY
          )
        end
      end
      
      context "a non-active subscription" do
        
        setup do
          Net::HTTP.any_instance.stubs(:get2).
            returns(mock_http_response { verify_product_subscription_response_body(false) })
        end
        
        should "return false" do
          assert !@ls.verify_product_subscription(
            TEST_PID,
            TEST_PRODUCT_CODE,
            TEST_ACCESS_KEY_ID,
            TEST_SECRET_ACCESS_KEY
          )
        end
      end
      
    end
    
    context "when the connection times out" do
      
      setup do
        Net::HTTP.any_instance.stubs(:get2).
          raises(Timeout::Error, 'Timed out')
      end
      
      should "raise a LicenseService::TimeoutError" do
        assert_raise(Devpay::Errors::LicenseService::TimeoutError) do
          @ls.activate_hosted_product(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN, TEST_ACCESS_KEY_ID, TEST_SECRET_ACCESS_KEY)
        end
      end
      
    end
    
    context "when Service Unavailable (HTTP 503)" do
      
      setup do
        Net::HTTP.any_instance.stubs(:timeout).returns(0.01)
      end
      
      should "retry the request" do
        Net::HTTP.any_instance.expects(:get2).
          times(Devpay::LicenseService::RETRIES_FOR_503).
          returns(mock_http_response('Net::HTTPServiceUnavailable', '503', 'Service Unavailable') { erred_response_body('ServiceUnavailable', 'Service Unavailable') })
        
        assert_raise(Devpay::Errors::LicenseService::ServiceUnavailable) do
          @ls.activate_hosted_product(
            TEST_ACTIVATION_KEY, 
            TEST_PRODUCT_TOKEN, 
            TEST_ACCESS_KEY_ID, 
            TEST_SECRET_ACCESS_KEY
          )
        end
      end

      context "and continues to be unavailable" do
        should "raise a ServiceUnavailable error" do
          Net::HTTP.any_instance.expects(:get2).
            at_least_once.
            returns(mock_http_response('Net::HTTPServiceUnavailable', '503', 'Service Unavailable') { erred_response_body('ServiceUnavailable', 'Service Unavailable') })
        
          assert_raise(Devpay::Errors::LicenseService::ServiceUnavailable) do
            @ls.activate_hosted_product(
              TEST_ACTIVATION_KEY, 
              TEST_PRODUCT_TOKEN, 
              TEST_ACCESS_KEY_ID, 
              TEST_SECRET_ACCESS_KEY
            )
          end
        end
      end

      context "and the service becomes available" do
        
        setup do
          Net::HTTP.any_instance.expects(:get2).
            times(2).
            returns(
              mock_http_response('Net::HTTPServiceUnavailable', '503', 'Service Unavailable') { erred_response_body('ServiceUnavailable', 'Service Unavailable') },
              mock_http_response { activate_hosted_product_response_body }
            )
        end
        
        should "not raise an error" do
          assert_nothing_raised(Exception) do
            @ls.activate_hosted_product(
              TEST_ACTIVATION_KEY, 
              TEST_PRODUCT_TOKEN, 
              TEST_ACCESS_KEY_ID, 
              TEST_SECRET_ACCESS_KEY
            )
          end
        end
        
        should "continue processing as normal" do
          assert_kind_of Devpay::ActivationResponse, @ls.activate_hosted_product(
            TEST_ACTIVATION_KEY, 
            TEST_PRODUCT_TOKEN, 
            TEST_ACCESS_KEY_ID, 
            TEST_SECRET_ACCESS_KEY
          )
        end
      end
      
    end
    
  end
  
end