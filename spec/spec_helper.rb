require 'active_record'
require 'transmuxer'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

require 'support/models'
require 'support/notifications'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
