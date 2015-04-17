module Transmuxer
  class Job

    class << self
      def progress(job_id)
        Zencoder::Job.progress(job_id).body['progress'].to_i
      end

      def resubmit(job_id)
        Zencoder::Job.resubmit(job_id)
      end
    end

    attr_accessor :input_url, :output_store_path, :notifications_url

    def initialize(attributes = {})
      @input_url = attributes[:input_url]
      @output_store_path = attributes[:output_store_path]
      @notifications_url = attributes[:notifications_url]
    end

    def start
      @job ||= Zencoder::Job.create encoding_settings

      started?
    end

    def started?
      @job && @job.success?
    end

    def id
      started? && @job.body["id"]
    end

    def errors
      @job && @job.errors
    end

    private

    def encoding_settings
      {
        input: input_url,
        outputs: [
          {
            label: "360p",
            format: "mp4",
            quality: 3,
            audio_quality: 3,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "640x360",
            base_url: output_store_path,
            filename: "360p.mp4",
            public: true
          },
          {
            label: "720p",
            format: "mp4",
            quality: 4,
            audio_quality: 4,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "1280x720",
            base_url: output_store_path,
            filename: "720p.mp4",
            public: true
          },
          {
            label: "1080p",
            format: "mp4",
            quality: 5,
            audio_quality: 5,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "1920x1080",
            base_url: output_store_path,
            filename: "1080p.mp4",
            public: true
          },
          {
            label: "hls-360p",
            source: "360p",
            type: "segmented",
            format: "ts",
            copy_audio: true,
            copy_video: true,
            hls_optimized_ts: false,
            instant_play: true,
            base_url: output_store_path,
            filename: "360p.m3u8",
            public: true,
            headers: {
              "x-amz-acl" => "public-read"
            },
            access_control: [
              {
                permission: "FULL_CONTROL",
                grantee: "aws@zencoder.com"
              },
              {
                permission: "READ",
                grantee: "http://acs.amazonaws.com/groups/global/AllUsers"
              }
            ],
            notifications: [
              {
                event: "seamless_playback",
                url: notifications_url
              }
            ]
          },
          {
            label: "hls-720p",
            source: "720p",
            type: "segmented",
            format: "ts",
            copy_audio: true,
            copy_video: true,
            hls_optimized_ts: false,
            instant_play: true,
            base_url: output_store_path,
            filename: "720p.m3u8",
            public: true,
            headers: {
              "x-amz-acl" => "public-read"
            },
            access_control: [
              {
                permission: "FULL_CONTROL",
                grantee: "aws@zencoder.com"
              },
              {
                permission: "READ",
                grantee: "http://acs.amazonaws.com/groups/global/AllUsers"
              }
            ],
            notifications: [
              {
                event: "seamless_playback",
                url: notifications_url
              }
            ]
          },
          {
            label: "hls-1080p",
            source: "1080p",
            type: "segmented",
            format: "ts",
            copy_audio: true,
            copy_video: true,
            hls_optimized_ts: false,
            instant_play: true,
            base_url: output_store_path,
            filename: "1080p.m3u8",
            public: true,
            headers: {
              "x-amz-acl" => "public-read"
            },
            access_control: [
              {
                permission: "FULL_CONTROL",
                grantee: "aws@zencoder.com"
              },
              {
                permission: "READ",
                grantee: "http://acs.amazonaws.com/groups/global/AllUsers"
              }
            ],
            notifications: [
              {
                event: "seamless_playback",
                url: notifications_url
              }
            ]
          },
          {
            type: "playlist",
            streams: [
              {
                resolution: "640x360",
                bandwidth: 256,
                path: "360p.m3u8"
              },
              {
                resolution: "1280x720",
                bandwidth: 1024,
                path: "720p.m3u8"
              },
              {
                resolution: "1920x1080",
                bandwidth: 2048,
                path: "1080p.m3u8"
              }
            ],
            base_url: output_store_path,
            filename: "index.m3u8",
            public: true
          }
        ],
        notifications: notifications_url
      }
    end
  end
end