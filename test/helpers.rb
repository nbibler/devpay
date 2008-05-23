require 'rexml/document'
require 'net/https'
require 'yaml'

TEST_PRODUCT_TOKEN      = "{ProductToken}b#q.079EUWQu;hsG2b0O3im<Ue=N9gum3UnLXNrrvd/ii0f5/y-MfnM:i7U+cWpOlxHxtWWa7KiAP$8U9+81ec3m89p4qvbY%h-IL_nJk36b8LHZly~TG3oZMhVMa'~HwAw3m$JO`bCP03f85sj4shHD2NANSZOyNWCQ5n>c#VCP[lF<Ce2az4Qh7m8-KI4d8pR.05]H7;OZYN{Jg{o=2ja51CS4EzlMEl77Zmh3EySvx4>G3CKbsRQ&gQ-T4gV4uk1!luzndC8N$2.w!M0UsqViczlPyfs6c5P8&Oacj6@Ibderfklpoiu="
TEST_PRODUCT_CODE       = "774F4FF8"
TEST_ACTIVATION_KEY     = "AC6PMWXPBRPDDB426RW4X76I2MXQ"
TEST_USER_TOKEN         = "{UserToken}AAMHVXNlclRrbvclYiO3ipJOw3Bw2iIvWRGdDvrMV87ixFvPs0JYxLc3NHofLYf5azDvSQMhme/KbT4xknH0vhg7NMgJFq1OVe9C2jUMMoL8U2uwCj58QfQNlTHCXLUT5Pz4+cmd/9lKrdc8W3COBzg6SLbrjCev57WlIsmmLbD59UrrRfLzyfBlOHbbMyIW6wE/9dF54tmu2XKI7W6VMEpflQXZs4YCjkOmQM6AOQJXTBvq9QJqSL3dkbjsWzvay5XlRHSNgQkWfbm5NYEYBHtM3bO4iWNGlIO8bPKE2Jfu8BZ6Mpy7qSluOXgs8atZnk2PXbQA+MPvSZcsgcDn/2P+wNSBsk45vGEQ167gnPhrWPo3h5XrazaS8xkLldBRczBpPNDVoe2NEg=="
TEST_PID                = "PPHUXKJYQBLH753XI5BBW5DMW54"
TEST_ACCESS_KEY_ID      = "ACCESSKEYID3214"
TEST_SECRET_ACCESS_KEY  = "TESTSECRETACCESSKEY12345"


##
# Resets an object's (instance, class, or module) attribute to the original 
# value after block execution.
#
def without_changing(object, attribute, &block)
  original = object.send(attribute)
  yield
  object.send("#{attribute}=", original)
end


module LicenseServiceTestHelper #:nodoc:
  
  private
  
  def mock_http_response(response_type = 'Net::HTTPSuccess', code = '200', message = 'OK', &block)
    YAML::load(<<-YAML
--- !ruby/object:#{response_type} 
  body: |-
    #{yield}
  body_exist: true
  code: #{code}
  header: 
    date: 
    - Fri, 23 May 2008 16:08:33 GMT
    server: 
    - AWSLicenseService
    transfer-encoding: 
    - chunked
  http_version: "1.1"
  message: #{message}
  read: true
  socket: 
    YAML
    )
  end

  def erred_response_body(code = 'UnsetErrorCode', message = 'Unset error message')
    %(<?xml version="1.0"?>
    <ErrorResponse xmlns="http://ls.amazonaws.com/doc/2007-06-05/"><Error><Type>Sender</Type><Code>#{code}</Code><Message>#{message}</Message><Detail/></Error><RequestId>c75dbc1c-af20-409a-95de-650bba351890</RequestId></ErrorResponse>)
  end

  def successful_response_body(&block)
    %(<?xml version="1.0"?>
    #{yield})
  end
  
  def activate_hosted_product_response_body
    successful_response_body { %(<ActivateHostedProductResponse><ActivateHostedProductResult><UserToken> {UserToken}thisismytestusertokenthisismytestusertoken</UserToken><PersistentIdentifier> TESTPERSISTENTIDENTIFIER </PersistentIdentifier><ResponseMetadata><RequestId> cb919c0a-9bce-4afe-9b48-9bdf2412bb67 </RequestId></ResponseMetadata></ActivateHostedProductResult></ActivateHostedProductResponse>) }
  end
  
  def get_active_subscriptions_response_body
    successful_response_body { %(<GetActiveSubscriptionsByPidResponse><GetActiveSubscriptionsByPidResult><ProductCode> 6883959E </ProductCode><ProductCode> 774F4FF8 </ProductCode></GetActiveSubscriptionsByPidResult><ResponseMetadata><RequestId> cb919c0a-9bce-4afe-9b48-9bdf2412bb67 </RequestId></ResponseMetadata></GetActiveSubscriptionsByPidResponse>) }
  end
  
  def verify_product_subscription_response_body(result = true)
    successful_response_body { %(<VerifyProductSubscriptionByPidResponse><VerifyProductSubscriptionByPidResult><Subscribed>#{result.to_s}</Subscribed></VerifyProductSubscriptionByPidResult><ResponseMetadata><RequestId> cb919c0a-9bce-4afe-9b48-9bdf2412bb67 </RequestId></ResponseMetadata></VerifyProductSubscriptionByPidResponse>) }
  end
  
end