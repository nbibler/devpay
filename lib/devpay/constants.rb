module Devpay

  ##
  # Contains the majority of the constants utilized by the Devpay plugin.
  #
  module Constants
    
    ##
    # Character (byte) length of the Amazon offer code
    #
    OFFER_CODE_LENGTH     = 8

    ##
    # Estimated formatting requirement for offer codes
    #
    OFFER_CODE_FORMAT     = /\A[\w]{#{Constants::OFFER_CODE_LENGTH}}\Z/
    
    ##
    # The basic Amazon DevPay purchase url (without offeringCode)
    #    
    PURCHASE_URL          = 'https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode='
    
  end
  
end