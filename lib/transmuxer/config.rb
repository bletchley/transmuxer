require 'singleton'

module Transmuxer
  class Config
    include Singleton

    attr_accessor :notifications_host, :cdn_host
    attr_reader :s3, :zencoder

    def initialize
      @s3 = S3Config.new
      @zencoder = ZencoderConfig.new
    end

    class ZencoderConfig
      def api_key=(api_key)
        Zencoder.api_key = api_key
      end
    end

    class S3Config
      attr_accessor :bucket_name
    end

  end
end
