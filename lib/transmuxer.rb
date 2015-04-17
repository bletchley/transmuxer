require "zencoder"

require "transmuxer/version"

require "transmuxer/config"
require "transmuxer/job"
require "transmuxer/transmuxable"
require "transmuxer/error"

require "transmuxer/engine"

module Transmuxer

  class << self
    def config(&block)
      yield Transmuxer::Config.instance if block
      Transmuxer::Config.instance
    end

    def notifications_base_uri
      Transmuxer.config.notifications_host + "/transmuxer/notifications"
    end
  end

end
