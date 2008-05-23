require File.dirname(__FILE__) + '/test_helper'

class ActivationTest < Test::Unit::TestCase
  
  context "Product activation (activate!)" do
    
    setup do
      @product  = Product.new
      @ls       = mock('License Service')
      @product.stubs(:product_token).returns(TEST_PRODUCT_TOKEN)
      Devpay.stubs(:license_service).returns(@ls)
    end
    
    context "in general" do
      
      context "the license service" do
        
        setup do
          Devpay.expects(:license_service).returns(@ls)
        end
        
        should "be used" do
          @ls.stubs(:activate_hosted_product).with(any_parameters).returns(TEST_USER_TOKEN)
          Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
        end
      
        should "be passed the activation key" do
          @ls.expects(:activate_hosted_product).with(TEST_ACTIVATION_KEY, anything, anything, anything).returns(TEST_USER_TOKEN)
          Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
        end

        should "be passed the product token" do
          @ls.expects(:activate_hosted_product).with(anything, TEST_PRODUCT_TOKEN, anything, anything).returns(TEST_USER_TOKEN)
          Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
        end
        
        context "access key id" do
        
          should "be passed the module variable" do
            without_changing Devpay, :access_key_id do
              Devpay.access_key_id  = 'abcd1234'
              @ls.expects(:activate_hosted_product).with(anything, anything, 'abcd1234', anything).returns(TEST_USER_TOKEN)
              Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
            end
          end

          should "be passed the given id" do
            @ls.expects(:activate_hosted_product).with(anything, anything, '4321dcba', anything).returns(TEST_USER_TOKEN)
            Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN, '4321dcba')
          end
        
        end
        
        context "secret access key" do
          
          should "be passed the module variable" do
            without_changing Devpay, :secret_access_key do
              Devpay.secret_access_key  = 'abcd1234'
              @ls.expects(:activate_hosted_product).with(anything, anything, anything, 'abcd1234').returns(TEST_USER_TOKEN)
              Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN)
            end
          end

          should "be passed the given key" do
            @ls.expects(:activate_hosted_product).with(anything, anything, anything, '4321dcba').returns(TEST_USER_TOKEN)
            Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN, nil, '4321dcba')
          end
        
        end
        
        context "when a problem occurs" do
          
          setup do
            @ls.stubs(:activate_hosted_product).with(any_parameters).raises(Devpay::Errors::LicenseServiceError, 'Test Exception')
          end
          
          should "raise a LicenseServiceError" do
            assert_raise(Devpay::Errors::LicenseServiceError) { Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN) }
          end
          
        end
        
      end
      
    end
    
  end
  
end