require 'net/https'
require 'openssl'
require 'digest/sha1'
require 'base64'
require 'cgi'
require 'rexml/document'
require 'time'

require 'devpay/activation_response'

module Devpay
  
  ##
  # The interface to communicating with the Amazon DevPay License Service.
  #
  # === SSL Required
  #
  # The Amazon License Service will not accept non-SSL enabled requests
  # (See page 117, DevPay Developer Guide, Version 2007-12-01).
  #
  # === Request Throttling
  #
  # Amazon reserves the right to throttle requests to their License Service 
  # as may become necessary.  During these throttling periods, the License
  # Service will return HTTP Error 503 (service unavailable) to ignored 
  # requests (See page 137, DevPay Developer Guide, Version 2007-12-01).
  #
  # This LicenseService implementation will retry 503 errors as many times as
  # is stipulated in the instance's @retries_for_503 variable, which defaults
  # to RETRIES_FOR_503.
  # 
  #
  class LicenseService
    
    # License Service host name
    HOST              = 'ls.amazonaws.com'
    
    # License Service port
    PORT              = 443
    
    # Toggle SSL requests
    USE_SSL           = true
    
    # Version of the License Service API being used
    VERSION           = '2008-04-28'
    
    # Version of the License Service Signature being used
    SIGNATURE_VERSION = '1'
    
    # Default timeout value (in seconds) used for both open and read timeouts
    TIMEOUT           = 5
    
    # Number of retries to perform if 503 (service unavailable).  Amazon may throttle the LS as necessary, returning 503.
    RETRIES_FOR_503   = 3
    
    # Number of seconds to delay between retries.
    RETRY_DELAY       = 0.5
    
    # Defaults to HOST value
    attr_accessor :host
    
    # Defaults to PORT value
    attr_accessor :port
    
    # Defaults to VERSION value
    attr_accessor :version
    
    # Defaults to TIMEOUT value
    attr_accessor :timeout
    
    # Defaults to RETRIES_FOR_503
    attr_accessor :retries_for_503
    
    # Defaults to RETRY_DELAY
    attr_accessor :retry_delay
    
    def initialize(options = {}) #:nodoc:
      @host       = options[:host]    || HOST
      @port       = options[:port]    || PORT
      @version    = options[:version] || VERSION
      @timeout    = options[:timeout] || TIMEOUT

      @retry_delay      = options[:retry_delay]     || RETRY_DELAY
      @retries_for_503  = options[:retries_for_503] || RETRIES_FOR_503
    end
    
    ##
    # Activates an +activation_key+ for the +product_token+ as a hosted DevPay
    # product.  Returns an instance of a Devpay::ActivationResponse with the
    # resulting user token and persistent identifier.
    #
    # ===== Exceptions
    #
    # Devpay::Errors::LicenseServiceError:: General error form, more specific errors will be raised that inherit from it
    # 
    #
    def activate_hosted_product(activation_key, product_token, access_key_id, secret_access_key)
      check_credentials access_key_id, secret_access_key
      
      arguments = {
        'Action'        => 'ActivateHostedProduct',
        'ActivationKey' => activation_key,
        'ProductToken'  => product_token
      }
      response_doc = make_request(signed_query_string(arguments, access_key_id, secret_access_key))

      ActivationResponse.new(
        :user_token             => extract_text(response_doc, "//UserToken"),
        :persistent_identifier  => extract_text(response_doc, "//PersistentIdentifier")
      )
    end

    ##
    # Returns an Array of product codes (as Strings) which are active for the 
    # given +pid+.
    #
    # ===== Exceptions
    #
    # Devpay::Errors::LicenseServiceError:: General error form, more specific errors will be raised that inherit from it
    #
    def get_active_subscriptions(pid, access_key_id, secret_access_key)
      check_credentials access_key_id, secret_access_key

      arguments = {
        'Action'                => 'GetActiveSubscriptionsByPid',
        'PersistentIdentifier'  => pid
      }
      response_doc = make_request(signed_query_string(arguments, access_key_id, secret_access_key))
      extract_multiple_text(response_doc, "//ProductCode")
    end
    
    ##
    # Returns +true+ if the given +pid+ is an active subscription for the 
    # given +product_code+.  Otherwise, returns +false+.
    #
    # ===== Exceptions
    #
    # Devpay::Errors::LicenseServiceError:: General error form, more specific errors will be raised that inherit from it
    #
    def verify_product_subscription(pid, product_code, access_key_id, secret_access_key)
      check_credentials access_key_id, secret_access_key

      arguments = {
        'Action'                => 'VerifyProductSubscriptionByPid',
        'PersistentIdentifier'  => pid,
        'ProductCode'           => product_code
      }
      response_doc  = make_request(signed_query_string(arguments, access_key_id, secret_access_key))
      response      = extract_text(response_doc, "//Subscribed")
      response == 'true'
    end
    
    
    private
    
    
    ##
    # Returns the text of a node in the given XML document at the given path.
    #
    def extract_text(document, path)
      node = REXML::XPath.first(document, path)
      node ? node.text.strip : nil
    end
    
    ##
    # Scans the +document+ for nodes which match the given +path+.  The text 
    # of those nodes are then collected into an Array and returned.
    #
    def extract_multiple_text(document, path)
      nodes = REXML::XPath.match(document, path)
      nodes ? nodes.collect { |node| node.text.strip } : nil
    end
    
    ##
    # Adds an encrypted signature to the request arguments.
    #
    def signed_query_string(arguments, access_key_id, secret_access_key)
      arguments['AWSAccessKeyId']     = access_key_id
      arguments['SignatureVersion']   = '1'
      arguments['Timestamp']          = Time.now.iso8601
      arguments['Version']            = @version
      
      arguments_for_encryption = arguments.sort { |key, value| key.first.downcase <=> value.first.downcase }
      arguments_for_encryption.collect! { |pair| pair.first.to_s + pair.last.to_s }

      arguments['Signature']          = Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha1'),
          secret_access_key,
          arguments_for_encryption.join('')
        )
      ).strip
      query_string arguments
    end
    
    ##
    # Creates the query string for the License Service request.
    #
    def query_string(arguments)
      path = arguments.to_a.collect { |p| "#{p.first}=#{CGI::escape(p.last)}" }.join('&')
      '/?' + path
    end
    
    ##
    # Makes an HTTP(S) request to the Amazon License Service with the given
    # path.
    # 
    # ===== Exceptions
    # 
    # Devpay::Errors::LicenseService::TimeoutError:: Raised when the License Service connection times out
    # Devpay::Errors::LicenseServiceError:: General form of other errors raised by the License Service
    # 
    def make_request(query_string)
      retry_count       = 1
      response          = nil

      http              = Net::HTTP.new(@host, @port)
      http.use_ssl      = true
      http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
      http.open_timeout = timeout
      http.read_timeout = http.open_timeout
      
      begin
        response        = http.get2(query_string)
        if response.kind_of?(Net::HTTPServiceUnavailable) && retry_count < @retries_for_503
          retry_count += 1
          sleep @retry_delay
          raise(Errors::LicenseService::ServiceUnavailable)
        end
      rescue Timeout::Error => e
        raise(Errors::LicenseService::TimeoutError, e.message, e.backtrace)
      rescue Errors::LicenseService::ServiceUnavailable
        retry
      end
      
      handle_response response
    end
    
    
    ##
    # Handles / routes an HTTPResponse, usually generated in make_request.
    #
    def handle_response(response)
      response_doc  = begin
                        REXML::Document.new(response.body)
                      rescue REXML::ParseException => e
                        nil
                      end
                      
      if response.kind_of? Net::HTTPSuccess
        return response_doc
      else
        response_doc ?
          raise_error(
            extract_text(response_doc, "//Code"),
            extract_text(response_doc, "//Message")
          ) :
          raise_error(response.class.to_s, 'No valid response returned')
      end
    end
    
    def check_credentials(access_key_id, secret_access_key)
      access_key_id     || raise(Errors::LicenseService::MissingCredentials, "Access key id not provided", caller)
      secret_access_key || raise(Errors::LicenseService::MissingCredentials, "Secret access key not provided", caller)
    end
    
    ##
    # Wraps the License Service response errors by raising an actual Ruby
    # error to later catch.
    #
    def raise_error(name, message = nil)
      name = name.split('::').last
      Errors::LicenseService.const_defined?(name.to_sym) ?
        raise(Errors::LicenseService.const_get(name.to_sym), message, caller) :
        raise(Errors::LicenseServiceError, "Error: #{name}: #{message}", caller)
    end
    
  end
  
end