require 'devpay/error'
require 'devpay/errors/errors'
require 'devpay/errors/license_service/errors'
require 'devpay/constants'
require 'devpay/license_service'
require 'devpay/helpers/graceful_requestor'

##
# Manages interactions with the Amazon DevPay system.
#
module Devpay
  include Constants
  
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
  # Devpay::Errors::LicenseServiceError:: Generic error occurring within the License Service
  #
  def self.purchase_url_for(offer_code)
    offer_code = offer_code.offer_code if offer_code.respond_to?(:offer_code)
    raise(Errors::LicenseService::InvalidOfferCode, "Invalid offer code given: #{offer_code.inspect}") unless valid_offer_code?(offer_code)
    PURCHASE_URL + offer_code
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
  # Devpay::Errors::LicenseServiceError:: Generic error occurring within the License Service
  #
  def self.activate!(activation_key, product_token, access_key_id = @@access_key_id, secret_access_key = @@secret_access_key)
    product_token = product_token.product_token if product_token.respond_to?(:product_token)
    
    license_service.activate_hosted_product(
      activation_key,
      product_token,
      access_key_id,
      secret_access_key
    )
  end
  
  ##
  # Returns an Array of active Product Codes (as Strings) for the given +pid+.
  #
  # The PID should be the Amazon-assigned persistent identifier for one of
  # your customers.  This PID should have been returned to you (and 
  # subsequently stored by you) following product activation.
  #
  # ===== Parameters
  #
  # pid:: Can either be a string or an object which responds to :persistent_identifier.  See activate!
  # access_key_id:: (Optional) Your Amazon access key identifier.  Defaults to Devpay.access_key_id
  # secret_access_key:: (Optional) Your Amazon secret access key.  Defaults to Devpay.secret_access_key
  #
  # ===== Exceptions
  #
  # Devpay::Errors::LicenseServiceError:: Generic error occurring within the License Service
  #
  def self.find_all_product_codes_for(pid, access_key_id = @@access_key_id, secret_access_key = @@secret_access_key)
    pid = pid.persistent_identifier if pid.respond_to?(:persistent_identifier)
    
    license_service.get_active_subscriptions(
      pid,
      access_key_id,
      secret_access_key
    )
  end

  ##
  # Returns +true+ if the subscription is active for the given 
  # +pid+ for the given +product_code+.
  #
  # ===== Parameters
  #
  # pid:: Can either be a string or an object which responds to :persistent_identifier.  See activate!
  # product_code:: Can either be a string or an object which responds to :product_code.  This is defined by DevPay during product registration.
  # access_key_id:: (Optional) Your Amazon access key identifier.  Defaults to Devpay.access_key_id
  # secret_access_key:: (Optional) Your Amazon secret access key.  Defaults to Devpay.secret_access_key
  #
  # ===== Exceptions
  #
  # Devpay::Errors::LicenseServiceError:: Generic error occurring within the License Service
  #
  def self.active?(pid, product_code, access_key_id = @@access_key_id, secret_access_key = @@secret_access_key)
    pid           = pid.persistent_identifier if pid.respond_to?(:persistent_identifier)
    product_code  = product_code.product_code if product_code.respond_to?(:product_code)
    
    license_service.verify_product_subscription(
      pid,
      product_code,
      access_key_id,
      secret_access_key
    )
  end
  
  
  private
  
  
  ##
  # Returns a new instance of an Amazon License Service object.
  #
  def self.license_service
    Devpay::LicenseService.new
  end
  
  def self.valid_offer_code?(code) #:nodoc:
    code =~ OFFER_CODE_FORMAT
  end
  
end