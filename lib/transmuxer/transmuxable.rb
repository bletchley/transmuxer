require 'active_support/concern'

module Transmuxer
  module Transmuxable
    extend ActiveSupport::Concern

    included do
      attr_reader :unprocessed_file_url, :processed_file_metadata

      define_model_callbacks :process, :fail
    end

    module ClassMethods
      def failed
        where(zencoder_job_state: 'failed')
      end

      def ready
        where(zencoder_job_state: 'finished')
      end

      def transmuxable(unprocessed_file_url)
        define_method :unprocessed_file_url do
          send unprocessed_file_url
        end
      end
    end

    def transmux
      job = Transmuxer::Job.new(
        input_url: unprocessed_file_url,
        output_store_path: processed_file_store_path,
        notifications_url: notifications_url
      )

      if job.start
        update_columns(
          zencoder_job_id: job.id,
          zencoder_job_state: "processing"
        )
      else
        raise JobNotStarted, job.errors
      end
    end

    def transmux_progress
      Transmuxer::Job.progress(zencoder_job_id)
    end

    def transmux_retry
      Transmuxer::Job.resubmit(zencoder_job_id)
    end

    def update_transmuxer_job(attrs = {})
      self.zencoder_job_state = attrs[:state]

      if processed?
        @processed_file_metadata = attrs[:metadata]
        run_callbacks :process
      elsif failed?
        run_callbacks :fail
      end

      self.save validate: false
    end

    def processed_file_store_path
      "s3://#{Transmuxer.config.s3.bucket_name}/#{self.class.name.tableize}/#{id}/processed"
    end

    def mp4_240_file_url
      "#{processed_file_store_url}/240p.mp4"
    end

    def mp4_web_360_file_url
      "#{processed_file_store_url}/web-360p.mp4"
    end

    def mp4_360_file_url
      "#{processed_file_store_url}/360p.mp4"
    end

    def mp4_480_file_url
      "#{processed_file_store_url}/480p.mp4"
    end

    def mp4_720_file_url
      "#{processed_file_store_url}/720p.mp4"
    end

    def mp4_1080_file_url
      "#{processed_file_store_url}/1080p.mp4"
    end

    def hls_file_url
      "#{processed_file_store_url}/index.m3u8"
    end

    def ready?
      processed?
    end

    def processed?
      zencoder_job_state == "finished"
    end

    def failed?
      zencoder_job_state == "failed"
    end

    private

    def processed_file_store_url
      "https://#{Transmuxer.config.s3.bucket_name}.s3.amazonaws.com/#{self.class.name.tableize}/#{id}/processed"
    end

    def notifications_url
      Transmuxer.notifications_base_uri + "/#{self.class.name.tableize}/#{id}"
    end
  end
end
