module Devpay

  ##
  # Contains the majority of the constants utilized by the Devpay plugin.
  #
  module Constants
    
    ##
    # Character (byte) length of the Amazon product code
    #
    PRODUCT_CODE_LENGTH   = 8
    
    ##
    # Character (byte) length of the Amazon offer code
    #
    OFFER_CODE_LENGTH     = 8
    
    PRODUCT_CODE_FORMAT   = /\A[\w]{#{Constants::PRODUCT_CODE_LENGTH}}\Z/
    OFFER_CODE_FORMAT     = /\A[\w]{#{Constants::OFFER_CODE_LENGTH}}\Z/
    PRODUCT_TOKEN_FORMAT  = /\A\{ProductToken\}.+\Z/
    USER_TOKEN_FORMAT     = /\A\{UserToken\}.+\Z/
    ACTIVATION_KEY_FORMAT = /\A[\w]+\Z/
    
    ##
    # The basic Amazon DevPay purchase url (without offeringCode)
    #    
    PURCHASE_URL          = 'https://aws-portal.amazon.com/gp/aws/user/subscription/index.html?offeringCode='
    
  end
  
end