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
            type: "segmented",
            format: "aac",
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_store_path,
            filename: "audio.m3u8",
            public: true
          },
          {
            label: "240p",
            format: "mp4",
            audio_bitrate: 128,
            audio_sample_rate: 44100,
            video_bitrate: 192,
            decoder_bitrate_cap: 288,
            decoder_buffer_size: 768,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "426x240",
            base_url: output_store_path,
            filename: "240p.mp4",
            public: true
          },
          {
            label: "web-360p",
            format: "mp4",
            audio_bitrate: 128,
            audio_sample_rate: 44100,
            video_bitrate: 400,
            decoder_bitrate_cap: 600,
            decoder_buffer_size: 1600,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "640x360",
            base_url: output_store_path,
            filename: "web-360p.mp4",
            public: true
          },
          {
            label: "360p",
            format: "mp4",
            audio_bitrate: 128,
            audio_sample_rate: 44100,
            video_bitrate: 750,
            decoder_bitrate_cap: 1125,
            decoder_buffer_size: 3000,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "640x360",
            base_url: output_store_path,
            filename: "360p.mp4",
            public: true
          },
          {
            label: "480p",
            format: "mp4",
            audio_bitrate: 128,
            audio_sample_rate: 44100,
            video_bitrate: 1000,
            decoder_bitrate_cap: 1500,
            decoder_buffer_size: 4000,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "854x480",
            base_url: output_store_path,
            filename: "480p.mp4",
            public: true
          },
          {
            label: "720p",
            format: "mp4",
            audio_bitrate: 128,
            audio_sample_rate: 44100,
            video_bitrate: 2500,
            decoder_bitrate_cap: 3750,
            decoder_buffer_size: 10000,
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
            audio_bitrate: 128,
            audio_sample_rate: 44100,
            video_bitrate: 4500,
            decoder_bitrate_cap: 6750,
            decoder_buffer_size: 18000,
            h264_reference_frames: "auto",
            forced_keyframe_rate: 0.1,
            size: "1920x1080",
            base_url: output_store_path,
            filename: "1080p.mp4",
            public: true
          },
          {
            label: "hls-240p",
            source: "240p",
            type: "segmented",
            format: "ts",
            copy_audio: true,
            copy_video: true,
            hls_optimized_ts: false,
            instant_play: true,
            base_url: output_store_path,
            filename: "240p.m3u8",
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
            label: "hls-web-360p",
            source: "web-360p",
            type: "segmented",
            format: "ts",
            copy_audio: true,
            copy_video: true,
            hls_optimized_ts: false,
            instant_play: true,
            base_url: output_store_path,
            filename: "web-360p.m3u8",
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
            label: "hls-480p",
            source: "480p",
            type: "segmented",
            format: "ts",
            copy_audio: true,
            copy_video: true,
            hls_optimized_ts: false,
            instant_play: true,
            base_url: output_store_path,
            filename: "480p.m3u8",
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
                resolution: "1920x1080",
                bandwidth: 5000,
                path: "1080p.m3u8"
              },
              {
                resolution: "1280x720",
                bandwidth: 2800,
                path: "720p.m3u8"
              },
              {
                resolution: "854x480",
                bandwidth: 1400,
                path: "480p.m3u8"
              },
              {
                resolution: "640x360",
                bandwidth: 1000,
                path: "360p.m3u8"
              },
              {
                resolution: "640x360",
                bandwidth: 600,
                path: "web-360p.m3u8"
              },
              {
                resolution: "426x240",
                bandwidth: 300,
                path: "240p.m3u8"
              },
              {
                bandwidth: 64,
                path: "audio.m3u8",
                codecs: "mp4a.40.5"
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