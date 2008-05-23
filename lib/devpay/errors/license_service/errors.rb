module Devpay
  module Errors #:nodoc:
    
    module LicenseService #:nodoc: all
      
      
      # Custom error added for timeouts
      class TimeoutError < Devpay::Errors::LicenseServiceError; end
      
      # The credentials provided were not recognized.
      class InvalidClientTokenId < Devpay::Errors::LicenseServiceError; end

      # Custom error added for offer code validation
      class InvalidOfferCode < Devpay::Errors::LicenseServiceError; end
      
      # All requests to the License Service were 503 Service Unavailable
      class ServiceUnavailable < Devpay::Errors::LicenseServiceError; end

      
      
      
      
      ##
      # General License Errors
      ##
      
      # Access to the resource is denied. 
      class AccessDenied < Devpay::Errors::LicenseServiceError; end

      # The provided security credentials are not valid. 
      class CannotValidateCredentials < Devpay::Errors::LicenseServiceError; end

      # The query parameter <parameter> is invalid. Its structure conflicts with that of another parameter. 
      class ConflictingQueryParameter < Devpay::Errors::LicenseServiceError; end

      # The element <element> is not signed. 
      class ElementNotSigned < Devpay::Errors::LicenseServiceError; end

      # We encountered an internal error. Please try again. 
      class InternalError < Devpay::Errors::LicenseServiceError; end

      # AWS was not able to validate the provided access credentials. 
      class InvalidAccessKeyId < Devpay::Errors::LicenseServiceError; end

      # The action <action> is not valid for this web service. 
      class InvalidAction < Devpay::Errors::LicenseServiceError; end

      # The address <address> is not valid for this web service. 
      class InvalidAddress < Devpay::Errors::LicenseServiceError; end

      # Invalid batch request. Reason: <reason>. 
      class InvalidBatchRequest < Devpay::Errors::LicenseServiceError; end

      # The HTTP authorization header is bad, use format: <format>. 
      class InvalidHttpAuthHeader < Devpay::Errors::LicenseServiceError; end

      # Invalid HTTP request. Reason: <reason>. 
      class InvalidHttpRequest < Devpay::Errors::LicenseServiceError; end

      # The parameter <parameter> cannot be used with the parameter <parameter>. 
      class InvalidParameterCombination < Devpay::Errors::LicenseServiceError; end

      # Value <value> for parameter <parameter> is invalid. Reason: <reason>. 
      class InvalidParameterValue < Devpay::Errors::LicenseServiceError; end

      # The query parameter <parameter> is invalid. Please see service documentation for correctsyntax. 
      class InvalidQueryParameter < Devpay::Errors::LicenseServiceError; end

      # The service cannot handle the request. Request is invalid. 
      class InvalidRequest < Devpay::Errors::LicenseServiceError; end

      # The following response groups are invalid: <groups>. 
      class InvalidResponseGroups < Devpay::Errors::LicenseServiceError; end

      # The provided security credentials are not valid. Reason: <reason>. 
      class InvalidSecurity < Devpay::Errors::LicenseServiceError; end

      # The security token used in the request is invalid. Reason: <reason>. 
      class InvalidSecurityToken < Devpay::Errors::LicenseServiceError; end

      # The Web Service <service> does not exist. 
      class InvalidService < Devpay::Errors::LicenseServiceError; end

      # Could not parse the specified URI: <URI>. 
      class InvalidURI < Devpay::Errors::LicenseServiceError; end

      # WS-Addressing parameter <parameter> has a wrong value: <value>. 
      class InvalidWSAddressingProperty < Devpay::Errors::LicenseServiceError; end

      # Invalid SOAP Signature. Reason: <reason>. 
      class MalformedSOAPSignature < Devpay::Errors::LicenseServiceError; end

      # Version not well formed: <version>. Must be in YYYY-MM-DD format. 
      class MalformedVersion < Devpay::Errors::LicenseServiceError; end

      # No action was supplied with this request. 
      class MissingAction < Devpay::Errors::LicenseServiceError; end

      # Request must contain AWSAccessKeyId or X.509 certificate. 
      class MissingClientTokenId < Devpay::Errors::LicenseServiceError; end

      # AWS was not able to authenticate the request: access credentials are missing. 
      class MissingCredentials < Devpay::Errors::LicenseServiceError; end

      # Authorized request must have a "date" or "x-amz-date" header. 
      class MissingDateHeader < Devpay::Errors::LicenseServiceError; end

      # The request must contain the parameter <parameter>. 
      class MissingParameter < Devpay::Errors::LicenseServiceError; end

      # Unexpected: missing SOAPRequestInfo from the request. 
      class MissingSOAPRequestInfo < Devpay::Errors::LicenseServiceError; end

      # WS-Addressing is missing a required parameter: <parameter>. 
      class MissingWSAddressingProperty < Devpay::Errors::LicenseServiceError; end

      # Attachment content is not available. 
      class NoAttachmentContent < Devpay::Errors::LicenseServiceError; end

      # No MIME boundary found for attachment part. 
      class NoMIMEBoundary < Devpay::Errors::LicenseServiceError; end

      # The requested version ( <version> ) is not valid. 
      class NoSuchVersion < Devpay::Errors::LicenseServiceError; end

      # Request has expired. 
      class RequestExpired < Devpay::Errors::LicenseServiceError; end

      # Request is throttled. 
      class RequestThrottled < Devpay::Errors::LicenseServiceError; end

      # SSL connection required for backward compatible SOAP authentication. 
      class RequiresSSL < Devpay::Errors::LicenseServiceError; end

      # Timestamp must be in XSD date format.
      class SOAP11IncorrectDateFormat < Devpay::Errors::LicenseServiceError; end

      # The <Action> request element is missing in SOAP 1.1 request. 
      class SOAP11MissingAction < Devpay::Errors::LicenseServiceError; end

      # Could not find the SOAP body in the request. 
      class SoapBodyMissing < Devpay::Errors::LicenseServiceError; end

      # Could not find the SOAP envelope in the request. 
      class SoapEnvelopeMissing < Devpay::Errors::LicenseServiceError; end

      # Could not parse the SOAP envelope. 
      class SoapEnvelopeParseError < Devpay::Errors::LicenseServiceError; end

      # The SOAP envelope exceeded the maximum allowed depth. 
      class SoapEnvelopeTooDeep < Devpay::Errors::LicenseServiceError; end

      # The SOAP envelope exceeded the maximum allowed length. 
      class SoapEnvelopeTooLong < Devpay::Errors::LicenseServiceError; end

      # Envelope Namespace must be for either SOAP 1.1: http://schemas.xmlsoap.org/soap/envelope, or SOAP 1.2: http://www.w3.org/2003/05/soap-envelope. 
      class UnknownEnvelopeNamespace < Devpay::Errors::LicenseServiceError; end

      # Encoding (most likely US-ASCII) not supported - internal service error. 
      class UnsupportedEncodingException < Devpay::Errors::LicenseServiceError; end

      # The requested HTTP verb is not supported: <verb>. 
      class UnsupportedHttpVerb < Devpay::Errors::LicenseServiceError; end

      # The URI exceeded the maximum limit of <length>. 
      class URITooLong < Devpay::Errors::LicenseServiceError; end

      # Signed info is corrupt. 
      class WSSecurityCorruptSignedInfo < Devpay::Errors::LicenseServiceError; end

      # Timestamp for created date must be in ISO8601 format. 
      class WSSecurityCreatedDateIncorrectFormat < Devpay::Errors::LicenseServiceError; end

      # BinarySecurityToken must have EncodingType of <type>. 
      class WSSecurityEncodingTypeError < Devpay::Errors::LicenseServiceError; end

      # Timestamp for expires date must be in ISO8601 format. 
      class WSSecurityExpiresDateIncorrectFormat < Devpay::Errors::LicenseServiceError; end

      # BinarySecurityToken has bad ValueType. 
      class WSSecurityIncorrectValuetype < Devpay::Errors::LicenseServiceError; end

      # BinarySecurityToken must have attribute ValueType. 
      class WSSecurityMissingValuetype < Devpay::Errors::LicenseServiceError; end

      # Request must not contain more than one BinarySecurityToken with valueType <type>. 
      class WSSecurityMultipleCredentialError < Devpay::Errors::LicenseServiceError; end

      # Request cannot contain more than one UsernameToken. 
      class WSSecurityMultipleUsernameError < Devpay::Errors::LicenseServiceError; end

      # Error while processing signature element. 
      class WSSecuritySignatureError < Devpay::Errors::LicenseServiceError; end

      # SignatureValue is missing or empty. 
      class WSSecuritySignatureMissing < Devpay::Errors::LicenseServiceError; end

      # Error while processing signed info. 
      class WSSecuritySignedInfoError < Devpay::Errors::LicenseServiceError; end

      # Request has no SignedInfo. 
      class WSSecuritySignedInfoMissing < Devpay::Errors::LicenseServiceError; end

      # Request has expired. 
      class WSSecurityTimestampExpired < Devpay::Errors::LicenseServiceError; end

      # Timestamp must have Expires element. 
      class WSSecurityTimestampExpiresMissing < Devpay::Errors::LicenseServiceError; end

      # Security Header Element is missing the timestamp element. 
      class WSSecurityTimestampMissing < Devpay::Errors::LicenseServiceError; end

      # UsernameToken must not contain Password. 
      class WSSecurityUsernameContainsPswd < Devpay::Errors::LicenseServiceError; end

      # Request must contain Username element in UsernameToken. 
      class WSSecurityUsernameMissing < Devpay::Errors::LicenseServiceError; end

      # Request cannot contain both Credential and an X.509 certificate. 
      class WSSecurityX509CertCredentialError < Devpay::Errors::LicenseServiceError; end

      # Request must not contain more than one BinarySecurityToken with valueType <type> or <type>. 
      class WSSecurityMultipleX509Error < Devpay::Errors::LicenseServiceError; end

      # Failed to check signature with X.509 certificate. 
      class WSSecurityX509SignatureError < Devpay::Errors::LicenseServiceError; end

      # Could not parse X.509 certificate. 
      class X509ParseError < Devpay::Errors::LicenseServiceError; end
      
      
      
      ##
      # Request-specific "special" errors
      ##
      
      # The activation key is expired. Activation keys expire one hour after creation. 
      class ExpiredActivationKey < Devpay::Errors::LicenseServiceError; end

      # The activation key does not correspond to the product token. Each activation key is associated with a particular customer and a particular product. This error occurs if you provide an activation key for a DevPay product other than the one represented by the product token. 
      class IncorrectActivationKey < Devpay::Errors::LicenseServiceError; end

      # The activation key is invalid or malformed. 
      class InvalidActivationKey < Devpay::Errors::LicenseServiceError; end

      # The persistent identifier (PID) is invalid or malformed. 
      class InvalidPersistentIdentifier < Devpay::Errors::LicenseServiceError; end

      # The product token is invalid for the signer. 
      class InvalidProductToken < Devpay::Errors::LicenseServiceError; end

      # The user token is invalid or malformed. 
      class InvalidUserToken < Devpay::Errors::LicenseServiceError; end

      # The request is missing the required parameter PersistentIdentifier. 
      class MissingPersistentIdentifier < Devpay::Errors::LicenseServiceError; end

      # The request is missing the required parameter ProductToken.
      class MissingProductToken < Devpay::Errors::LicenseServiceError; end

      # The request is missing the required parameter UserToken. 
      class MissingUserToken < Devpay::Errors::LicenseServiceError; end

      # The customer's subscription to your product is pending because the customer's sign-up payment failed. This can happen if the customer provided an invalid credit card, for example. 
      class UserNotSubscribed < Devpay::Errors::LicenseServiceError; end

    end
    
  end
end