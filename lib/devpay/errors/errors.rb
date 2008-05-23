module Devpay
  module Errors #:nodoc:
    
    ##
    # Raised when an error occurs when dealing with the License Service.
    #
    # There are many more specific errors that may be raised, but all
    # are inherited from LicenseServiceError.  
    #
    # See lib/devpay/errors/license_server/errors.rb for all other errors.
    #
    class LicenseServiceError < Devpay::Error; end
    
  end
end