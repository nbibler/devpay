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

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define(:version => 1) do
  create_table :products do |t|
    t.string :offer_code
  end
end

class Product < ActiveRecord::Base
end