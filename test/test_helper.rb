$LOAD_PATH.unshift 'lib/'

require 'rubygems'
require 'multi_rails_init'
require 'action_controller/test_process'
require 'test/unit'
require 'mocha'
require 'shoulda'

begin
  require 'redgreen'
rescue LoadError
  nil
end

require 'devpay'

RAILS_ROOT  = '.'     unless defined? RAILS_ROOT
RAILS_ENV   = 'test'  unless defined? RAILS_ENV

require 'schema'
require 'models'
require 'helpers'