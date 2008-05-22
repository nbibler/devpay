require File.dirname(__FILE__) + '/test_helper'

class ActivationTest < Test::Unit::TestCase
  
  TEST_PRODUCT_TOKEN    = "{ProductToken}b#q.079EUWQu;hsG2b0O3im<Ue=N9gum3UnLXNrrvd/ii0f5/y-MfnM:i7U+cWpOlxHxtWWa7KiAP$8U9+81ec3m89p4qvbY%h-IL_nJk36b8LHZly~TG3oZMhVMa'~HwAw3m$JO`bCP03f85sj4shHD2NANSZOyNWCQ5n>c#VCP[lF<Ce2az4Qh7m8-KI4d8pR.05]H7;OZYN{Jg{o=2ja51CS4EzlMEl77Zmh3EySvx4>G3CKbsRQ&gQ-T4gV4uk1!luzndC8N$2.w!M0UsqViczlPyfs6c5P8&Oacj6@Ibderfklpoiu="
  TEST_ACTIVATION_KEY   = "AC6PMWXPBRPDDB426RW4X76I2MXQ"
  TEST_USER_TOKEN       = "{UserToken}AAMHVXNlclRrbvclYiO3ipJOw3Bw2iIvWRGdDvrMV87ixFvPs0JYxLc3NHofLYf5azDvSQMhme/KbT4xknH0vhg7NMgJFq1OVe9C2jUMMoL8U2uwCj58QfQNlTHCXLUT5Pz4+cmd/9lKrdc8W3COBzg6SLbrjCev57WlIsmmLbD59UrrRfLzyfBlOHbbMyIW6wE/9dF54tmu2XKI7W6VMEpflQXZs4YCjkOmQM6AOQJXTBvq9QJqSL3dkbjsWzvay5XlRHSNgQkWfbm5NYEYBHtM3bO4iWNGlIO8bPKE2Jfu8BZ6Mpy7qSluOXgs8atZnk2PXbQA+MPvSZcsgcDn/2P+wNSBsk45vGEQ167gnPhrWPo3h5XrazaS8xkLldBRczBpPNDVoe2NEg=="
  TEST_PID              = "PPHUXKJYQBLH753XI5BBW5DMW54"
  
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
            @ls.stubs(:activate_hosted_product).with(any_parameters).raises(RuntimeError, 'Test Exception')
          end
          
          should "raise a LicenseServiceError" do
            assert_raise(Devpay::Errors::LicenseServiceError) { Devpay.activate!(TEST_ACTIVATION_KEY, TEST_PRODUCT_TOKEN) }
          end
          
        end
        
      end
      
    end
    
  end
  
end