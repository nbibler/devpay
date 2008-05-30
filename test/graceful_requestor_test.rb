require File.dirname(__FILE__) + '/test_helper'

class GracefulRequestorTest < Test::Unit::TestCase
  include LicenseServiceTestHelper
  
  context "A Graceful Requestor" do
    
    setup do
      Devpay.access_key_id      = TEST_ACCESS_KEY_ID
      Devpay.secret_access_key  = TEST_SECRET_ACCESS_KEY
      @requestor                = Devpay::Helpers::GracefulRequestor
    end
    
    [
      Devpay::Errors::LicenseService::ExpiredActivationKey,
      Devpay::Errors::LicenseService::IncorrectActivationKey,
      Devpay::Errors::LicenseService::InvalidActivationKey,
      Devpay::Errors::LicenseService::ServiceUnavailable,
      Devpay::Errors::LicenseService::TimeoutError,
      Devpay::Errors::LicenseService::UserNotSubscribed
    ].each do |error|
      
      context "receiving a #{error} during activation" do
        
        setup do
          error_name = error.to_s.split('::').last
          Net::HTTP.any_instance.expects(:get2).returns(mock_http_response('Net::HTTPForbidden', '403', 'Forbidden') { erred_response_body(error_name, "#{error} raised") })
        end
      
        should "contain the error" do
          assert_nothing_raised(error) do
            @requestor.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
          end
        end
        
        should "return an activation response" do
          assert_kind_of Devpay::ActivationResponse, @requestor.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
        end
        
        context "the activation response" do
          
          setup do
            @response = @requestor.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
          end
          
          should "be unsuccessful" do
            assert !@response.successful?
          end
          
          should "contain the error code" do
            assert_equal error.to_s, @response.code
          end
          
          should "contain the error message" do
            assert_equal "#{error} raised", @response.message
          end
          
        end
        
        context "with custom messages" do
          
          setup do
            @requestor.stubs(:custom_message_for).returns("Custom error message")
          end
          
          should "return the custom message" do
            assert_equal "Custom error message", @requestor.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN).message
          end
          
        end

      end
      
    end
    
  end
  
end
