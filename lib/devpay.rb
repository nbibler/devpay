require 'devpay/errors'
require 'devpay/constants'
require File.dirname(__FILE__) + '/../vendor/ls'

##
# Manages interactions with the Amazon DevPay system.
#
module Devpay
  
  # Amazon Access Key ID
  mattr_accessor :access_key_id
  
  # Amazon Secret Access Key
  mattr_accessor :secret_access_key
  
  ##
  # Returns a fully-qualified URL with the given offer code.  The +offer_code+
  # parameter may be either a +String+ (Amazon offer code) or an object which
  # responds to an +offer_code+ method call.
  #
  # ===== What happens next?
  #
  # When the user successfully purchases the product, they will be redirected
  # back to your site (to the url provided by you when you registered 
  # {your DevPay product}[http://aws.amazon.com/devpayactivity]) with 
  # query string parameters containing the Activation Key and purchased 
  # Product Code.
  #
  # ===== Parameters
  #
  # offer_code:: Can either be a String or an object which responds to :offer_code.  This value was given to you buy Amazon at DevPay product registration.
  #
  # ===== Exceptions
  #
  # Devpay::Errors::InvalidOfferCode:: If the given or retrieved offer code is not valid.
  #
  def self.purchase_url_for(offer_code)
    offer_code = offer_code.offer_code if offer_code.respond_to?(:offer_code)
    raise(Errors::InvalidOfferCode, "Invalid offer code given: #{offer_code.inspect}") unless valid_offer_code?(offer_code)
    Constants::PURCHASE_URL + offer_code
  end
  
  ##
  # Contacts the Amazon License Service to activate the given 
  # +activation_key+ for the given +product_token+ and returns a User Token
  # and Persistent Identifier for the customer.
  #
  #    user_token, pid = Devpay.activate!(activation_key, product_token)
  #
  # ==== Usage Notes
  #
  # The User Token should be permenantly stored and associated with
  # your customer's records. It is your responsibility to design your
  # site so that it can recognize each customer an retrieve the user token
  # associated with that customer.
  #
  # Amazon also suggests that you encrypt the token prior to storage.  
  #
  #     "If the user token is ever missing, the product must get a new one." -- Amazon
  #
  # ===== Hosted DevPay products only
  #
  # This method will only activate 'hosted' DevPay products.  This should not 
  # be used for 'desktop' DevPay products.
  #
  # ===== Parameters
  #
  # activation_key:: A String received either directly from an Amazon query-string redirection or provided by your customer.
  # product_token:: A String or object which responds to :product_token.  This value was provided to you when you registered your DevPay product.
  #
  # ===== Exceptions
  #
  # Devpay::Errors::InvalidProductToken:: If the given or retrieved product token is not valid.
  # Devpay::Errors::LicenseServiceError:: If an error occurs when contacting the Amazon License Service.
  #
  def self.activate!(activation_key, product_token, access_key_id = @@access_key_id, secret_access_key = @@secret_access_key)
    product_token = product_token.product_token if product_token.respond_to?(:product_token)
    raise(Errors::InvalidProductToken, "Invalid product token given: #{product_token.inspect}") unless valid_product_token?(product_token)
    raise(Errors::InvalidActivationKey, "Invalid activation key given: #{activation_key.inspect}") unless valid_activation_key?(activation_key)
    
    begin
      license_service.activate_hosted_product(
        activation_key,
        product_token,
        access_key_id,
        secret_access_key
      )
    rescue RuntimeError => e
      raise(Errors::LicenseServiceError, e.message, e.backtrace)
    end
  end
  
  
  private
  
  
  ##
  # Returns +true+ if the given code is a valid Amazon offer code.
  #
  def self.valid_offer_code?(code)
    code =~ Constants::OFFER_CODE_FORMAT
  end
  
  ##
  # Returns +true+ if the given token is a valid Amazon product token.
  #
  def self.valid_product_token?(token)
    token =~ Constants::PRODUCT_TOKEN_FORMAT
  end
  
  ##
  # Returns +true+ if the given code is a valid Amazon product code.
  #
  def self.valid_product_code?(code)
    code =~ Constants::PRODUCT_CODE_FORMAT
  end
  
  ##
  # Returns +true+ if the given key is a valid Amazon activation key.
  #
  def self.valid_activation_key?(key)
    key =~ Constants::ACTIVATION_KEY_FORMAT
  end
  
  ##
  # Returns a new instance of an Amazon License Service object.
  #
  def self.license_service
    DevPay::LicenseService.new
  end
  
end