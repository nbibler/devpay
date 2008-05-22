ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define(:version => 1) do
  create_table :products do |t|
    t.string :offer_code
  end
end
