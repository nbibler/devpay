require 'rexml/document'

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
  
  def unsuccessful_http_response(code = 'ExpiredActivationKey', message = 'The activation key has expired')
    response = mock('HTTP Response')
    response.stubs(:body).returns(erred_request_body(code, message))
    response
  end
  
  def activate_hosted_product_success
    REXML::Document.new(<<-XML
      <ActivateHostedProductResponse>
        <ActivateHostedProductResult>
          <UserToken> 
            {UserToken}thisismytestusertokenthisismytestusertoken
          </UserToken>
          <PersistentIdentifier> 
            TESTPERSISTENTIDENTIFIER 
          </PersistentIdentifier>
          <ResponseMetadata>
            <RequestId> 
              cb919c0a-9bce-4afe-9b48-9bdf2412bb67 
            </RequestId>
          </ResponseMetadata>
        </ActivateHostedProductResult>
      </ActivateHostedProductResponse>
      XML
    )
  end
  
  def get_active_subscriptions_success
    REXML::Document.new(<<-XML
      <GetActiveSubscriptionsByPidResponse>
        <GetActiveSubscriptionsByPidResult>
          <ProductCode> 
            6883959E 
          </ProductCode>
          <ProductCode> 
            774F4FF8 
          </ProductCode>
        </GetActiveSubscriptionsByPidResult>
        <ResponseMetadata>
          <RequestId> 
            cb919c0a-9bce-4afe-9b48-9bdf2412bb67 
          </RequestId>
        </ResponseMetadata>
      </GetActiveSubscriptionsByPidResponse>
    XML
    )
  end
  
  def verify_product_subscription_response(result = 'true')
    REXML::Document.new(<<-XML
      <VerifyProductSubscriptionByPidResponse>
        <VerifyProductSubscriptionByPidResult>
          <Subscribed> 
            #{result}
          </Subscribed>
        </VerifyProductSubscriptionByPidResult>
        <ResponseMetadata>
          <RequestId> 
            cb919c0a-9bce-4afe-9b48-9bdf2412bb67 
          </RequestId>
        </ResponseMetadata>
      </VerifyProductSubscriptionByPidResponse>
    XML
    )
  end
  
  def erred_request_body(code, message)
    <<-XML
      <ErrorResponse xmlns="http://ls.amazonaws.com/doc/2007-06-05/">
        <Error>
          <Type> 
            Sender 
          </Type>
          <Code> 
            #{code} 
          </Code>
          <Message> 
            #{message} 
          </Message>
          <Detail/>
        </Error>
        <RequestId> 
          c75dbc1c-af20-409a-95de-650bba351890 
        </RequestId>
      </ErrorResponse>
    XML
  end
  
end