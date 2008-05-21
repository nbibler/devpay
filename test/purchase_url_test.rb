require 'test_helper'

class PurchaseUrlTest < Test::Unit::TestCase
  
  context "The purchase url (purchase_url_for)" do
    
    setup do
      @product = Product.new
      @product.stubs(:offer_code).returns("ABCD1234")
    end
    
    context "in general" do
      
      should "use HTTPS" do
        assert_match /\Ahttps:\/\//, Devpay.purchase_url_for(@product)
      end
    
      should "link to Amazon's aws-portal" do
        assert_match /aws-portal\.amazon\.com/, Devpay.purchase_url_for(@product)
      end
    
      should "link to the proper location" do
        assert_match /\/gp\/aws\/user\/subscription\/index\.html/, Devpay.purchase_url_for(@product)
      end

      should "contain an offeringCode parameter" do
        assert_match /\?.*offeringCode=/, Devpay.purchase_url_for(@product)
      end
      
    end
    
    context "when given an object" do
      
      should "contain the object's offer code" do
        @product.expects(:offer_code).returns("ABCD1234")
        assert_match /\?.*offeringCode=ABCD1234/, Devpay.purchase_url_for(@product)
      end
      
      context "that doesn't respond to offer code" do
        should "raise InvalidOfferCode" do
          assert_raise(Devpay::Errors::InvalidOfferCode) { Devpay.purchase_url_for(Hash) }
        end
      end
      
    end
    
    context "when given a string" do
      
      should "use the string as the offer code" do
        assert_match /\?.*offeringCode=1234ABCD/, Devpay.purchase_url_for("1234ABCD")
      end
      
      context "that is not valid" do
        should "raise InvalidOfferCode" do
          assert_raise(Devpay::Errors::InvalidOfferCode) { Devpay.purchase_url_for("ab") }
        end
      end
      
    end
    
  end
  
  
end