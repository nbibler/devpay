module Devpay
  
  ##
  # This is a catch-all error for anything raised through the Devpay plugin.
  # This will allow you to query for specific errors raised, or anything 
  # raised, at all.
  #
  #   begin
  #     Devpay.erring.call
  #   rescue Devpay::SpecificError
  #     .. do something specifically useful ..
  #   rescue Devpay::Error
  #     .. do something generally useful that tripped something other than SpecificError ..
  #   end
  #
  class Error < Exception; end
  
  module Errors #:nodoc:
    
    ##
    # Raised when a method using an offer code receives an invalid code.
    #
    class InvalidOfferCode < Devpay::Error; end

    ##
    # Raised when a method using the product code receives an invalid code.
    #
    class InvalidProductCode < Devpay::Error; end

    ##
    # Raised when a method using the product token receives an invalid token.
    #
    class InvalidProductToken < Devpay::Error; end
    
    ##
    # Raised when a method using an activation key receives and invalid key.
    #
    class InvalidActivationKey < Devpay::Error; end
    
    ##
    # Raised when an error occurs when dealing with the License Service
    #
    class LicenseServiceError < Devpay::Error; end
    
  end
  
end