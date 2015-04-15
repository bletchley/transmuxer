require 'active_record'

load File.dirname(__FILE__) + '/schema.rb'

# A transmuxable model
class Video < ActiveRecord::Base
  include Transmuxer::Transmuxable
end
