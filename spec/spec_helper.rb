require 'active_record'
require 'transmuxer'

# Avoid an +undefined method 'env'+ error in Rails 4.1.
# See: https://git.io/vPttn and https://git.io/vPtqO
if defined?(Rails)
  unless Rails.respond_to?(:env)
    module ActiveRecord
      module ConnectionHandling
        RAILS_ENV = -> { 'test' }
      end
    end
  end
end

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

require 'support/models'
require 'support/notifications'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
