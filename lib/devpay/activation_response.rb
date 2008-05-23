module Devpay
  
  class ActivationResponse
    
    # Unique token for the activated user
    attr_accessor :user_token
    
    # Persistent identifier for the user
    attr_accessor :persistent_identifier
    
    def initialize(options = {}) #:nodoc:
      @user_token             = options[:user_token]
      @persistent_identifier  = options[:persistent_identifier]
    end
    
  end
  
end