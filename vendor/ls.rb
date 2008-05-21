###############################################################################
# Copyright 2007 Amazon Technologies, Inc.  Licensed under the Apache License,
# Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. You may 
# obtain a copy of the License at:
#
# http://aws.amazon.com/apache2.0
#
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
# CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
###############################################################################

# This file contains the code to communicate with AmazonLS.

require 'base64'
require 'cgi'
require 'net/https'
require 'openssl'
require 'rexml/document'
require 'time'

module DevPay
    DEFAULT_HOST = 'ls.amazonaws.com'
    DEFAULT_PORT = 443
    DEFAULT_USE_SSL = true 
    DEFAULT_VERSION = '2008-04-28'
  
    class LicenseService
        def initialize(args={})
          
            @use_ssl=DEFAULT_USE_SSL
            @host=args[:host]       ||  DEFAULT_HOST
            @port=args[:port]       ||  DEFAULT_PORT
            @version=args[:version] ||  DEFAULT_VERSION
            @use_ssl=args[:use_ssl] if args.has_key?(:use_ssl)
              
          
          
          
        end
        # Make an Activate Hosted Product call.  This call requires
        # the developer's AWS Access Key Id and the Secret Access Key
        # to sign the request.
        def activate_hosted_product(activation_key,
                product_token,
                access_key_id,
                secret_access_key)
            path_args = {
                'Action' => 'ActivateHostedProduct',
                'Version' => @version,
                'ActivationKey' => activation_key,
                'ProductToken' => product_token
            }
            res_doc = make_request(get_signed_path(path_args, access_key_id, secret_access_key))
            extract_text(res_doc, "//UserToken")
        end

        # Make an Activate Desktop Product call.  This is an unsigned
        # call to AmazonLS.
        def activate_desktop_product(activation_key, product_token)
            path_args = {
                'Action' => 'ActivateDesktopProduct',
                'Version' => @version,
                'ActivationKey' => activation_key,
                'ProductToken' => product_token
            }
            res_doc = make_request(get_path(path_args))
            user_token = extract_text(res_doc, "//UserToken")
            access_key_id = extract_text(res_doc, "//AWSAccessKeyId")
            secret_access_key = extract_text(res_doc, "//SecretAccessKey")
            Credentials.new(user_token, access_key_id, secret_access_key)
        end
    
        private 
    
        # Extracts text from a document given the XPath expression.
        def extract_text(doc, path)
            node = REXML::XPath.first(doc, path)
            return nil if !node
            node.text
        end
  
        # Creates the query path
        def get_path(args)
            path = ''
            args.each do |key, value|
                path << "&" if path != ""
                path << key << "=" << CGI::escape(value)
            end
            "/?" + path
        end
  
        # Creates a signed query path
        def get_signed_path(args, access_key_id, secret_access_key)
            args['AWSAccessKeyId'] = access_key_id
            args['SignatureVersion'] = "1"
            args['Timestamp'] = Time.now.iso8601
            s_to_sign = ''
            args.sort { |a, b| a[0].downcase <=> b[0].downcase }.each do |key, value|
                s_to_sign += key + value
            end
            digest = OpenSSL::Digest::Digest.new('sha1')
            args['Signature'] = Base64.encode64(OpenSSL::HMAC.digest(
                    digest, secret_access_key, s_to_sign)).strip
            get_path(args)
        end
   
        # Makes a call to AmazonLS
        def make_request(path)
            http = Net::HTTP.new(@host, @port)
            http.use_ssl = @use_ssl

            http.start do
                res = http.request(Net::HTTP::Get.new(path))
                res_doc = REXML::Document.new(res.body)
                if !res.is_a? Net::HTTPSuccess
                    code = extract_text(res_doc, "//Code")
                    message = extract_text(res_doc, "//Message")
                    raise RuntimeError, message, code
                end
                return res_doc
            end
        end
 
    end

    class Credentials
        attr_accessor :user_token, :access_key_id, :secret_access_key
        def initialize(user_token, access_key_id, secret_access_key)
            @user_token = user_token
            @access_key_id = access_key_id
            @secret_access_key = secret_access_key
        end
    end
end
