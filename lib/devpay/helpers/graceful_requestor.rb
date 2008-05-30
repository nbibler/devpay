module Devpay #:nodoc:
  module Helpers #:nodoc:

    ##
    # == GracefulRequestor
    #
    # A GracefulRequestor acts as a wrapper to Devpay methods, catching 
    # common errors and returning failure objects / notifications rather than
    # allowing those errors to bubble up.
    #
    # === Example
    # 
    #     
    #
    class GracefulRequestor
      
      ##
      # Wraps Devpay.activate!, catching likely errors raised due to invalid
      # data provided by your customer (bad Activation Key, for example) and
      # returning an unsuccessful ActivationResponse, instead.
      #
      # ===== Returns
      #
      # Returns a Devpay::ActivationResponse.  If the response was successful
      # (response.successful?), meaning the activation succeeded, it will 
      # contain the User Token and Persistent Identifier (PID).
      #
      # If the response was unsuccessful, it will contain the raised code
      # (name of the error) and message.
      #
      # Exceptions raised that are not listed below will still be raised.
      #
      # ===== Exceptions Caught
      #
      # See lib/devpay/errors/license_service/errors.rb for details about each
      # error listed below.
      #
      # * Devpay::Errors::LicenseService::ExpiredActivationKey
      # * Devpay::Errors::LicenseService::IncorrectActivationKey
      # * Devpay::Errors::LicenseService::InvalidActivationKey
      # * Devpay::Errors::LicenseService::ServiceUnavailable
      # * Devpay::Errors::LicenseService::TimeoutError
      # * Devpay::Errors::LicenseService::UserNotSubscribed
      #
      def self.activate!(activation_key, product_token, access_key_id = Devpay.access_key_id, secret_access_key = Devpay.secret_access_key)
        Devpay.activate!(activation_key, product_token, access_key_id, secret_access_key)
      rescue  Devpay::Errors::LicenseService::ExpiredActivationKey,
              Devpay::Errors::LicenseService::IncorrectActivationKey,
              Devpay::Errors::LicenseService::InvalidActivationKey,
              Devpay::Errors::LicenseService::ServiceUnavailable,
              Devpay::Errors::LicenseService::TimeoutError,
              Devpay::Errors::LicenseService::UserNotSubscribed
        ActivationResponse.new({
          :code     => $!.class.to_s,
          :message  => custom_message_for($!) || $!.message
        })
      end
      
      
      private
      
      
      ##
      # Inherit this class into a custom requestor class and override this 
      # method to return custom error messages for error codes.
      #
      # ===== Example
      #
      # Below is an example of how to add custom error messages to your 
      # application through the response messages:
      #
      #     def self.custom_devpay_message_for(error)
      #       case error
      #       when Devpay::Errors::LicenseService::ExpiredActivationKey
      #         %w(
      #         The activation key you've provided has expired.  Please go
      #         to your Amazon activation page and generate a new activation
      #         key.
      #         )
      #       else
      #         nil  # Uses the Amazon error message.
      #       end
      #     end
      #
      def self.custom_message_for(error)
        nil
      end
      
    end
    
  end
end