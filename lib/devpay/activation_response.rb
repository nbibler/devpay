module Devpay
  
  class ActivationResponse
    
    # Unique token for the activated user
    attr_accessor :user_token
    
    # Persistent identifier for the user
    attr_accessor :persistent_identifier
    
    # Error code returned by the LicenseService
    attr_accessor :code
    
    # Message associated with the code
    attr_accessor :message
    
    def initialize(options = {}) #:nodoc:
      @user_token             = options[:user_token]
      @persistent_identifier  = options[:persistent_identifier]
      @code                   = options[:code]
      @message                = options[:message]
    end
    
    ##
    # Returns +true+ unless the response contains an error code
    #
    def successful?
      @code.nil?
    end
    
  end
  
end