module Devpay
  
  ##
  # This is a catch-all error for anything raised through the Devpay plugin.
  # This will allow you to query for specific errors raised, or anything 
  # raised, at all.
  #
  #   begin
  #     Devpay.erring.call
  #   rescue Devpay::SpecificError
  #     .. do something specifically useful ..
  #   rescue Devpay::Error
  #     .. do something generally useful that tripped something other than SpecificError ..
  #   end
  #
  class Error < RuntimeError; end
  
end