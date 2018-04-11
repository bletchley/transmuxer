module Transmuxer
  class Job

    class << self
      def progress(job_id)
        Zencoder::Job.progress(job_id).body['progress'].to_i
      end

      def resubmit(job_id)
        Zencoder::Job.resubmit(job_id)
      end

      def cancel(job_id)
        Zencoder::Job.cancel(job_id)
      end
    end

    attr_accessor :input_url,
      :output_store_path,
      :notifications_url,
      :caption_file_url,
      :audio

    def initialize(attributes = {})
      @input_url = attributes[:input_url]
      @output_store_path = attributes[:output_store_path]
      @notifications_url = attributes[:notifications_url]
      @caption_file_url = attributes[:caption_file_url]
      @audio = !!attributes[:audio]
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

    def audio_outputs
      [{
        format: "mp3",
        audio_quality: 4,
        base_url: output_store_path,
        filename: "audio.mp3",
        public: true
      }]
    end

    def video_outputs
      outputs = [
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
          audio_constant_bitrate: true,
          video_bitrate: 192,
          decoder_bitrate_cap: 288,
          decoder_buffer_size: 1152,
          h264_reference_frames: "auto",
          forced_keyframe_rate: 0.1,
          size: "426x240",
          base_url: output_store_path,
          filename: "240p.mp4",
          public: true
        },
        {
          label: "360p",
          format: "mp4",
          audio_bitrate: 128,
          audio_sample_rate: 44100,
          audio_constant_bitrate: true,
          video_bitrate: 750,
          decoder_bitrate_cap: 1125,
          decoder_buffer_size: 4500,
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
          audio_constant_bitrate: true,
          video_bitrate: 1000,
          decoder_bitrate_cap: 1500,
          decoder_buffer_size: 6000,
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
          audio_constant_bitrate: true,
          video_bitrate: 2500,
          decoder_bitrate_cap: 3750,
          decoder_buffer_size: 15000,
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
          audio_constant_bitrate: true,
          video_bitrate: 4500,
          decoder_bitrate_cap: 6750,
          decoder_buffer_size: 27000,
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
          ]
        },
        {
          type: "playlist",
          streams: [
            {
              source: "hls-1080p",
              path: "1080p.m3u8"
            },
            {
              source: "hls-720p",
              path: "720p.m3u8"
            },
            {
              source: "hls-480p",
              path: "480p.m3u8"
            },
            {
              source: "hls-360p",
              path: "360p.m3u8"
            },
            {
              source: "hls-240p",
              path: "240p.m3u8"
            }
          ],
          base_url: output_store_path,
          filename: "index.m3u8",
          public: true
        }
      ]
      if caption_file_url
        outputs.each do |o|
          if o[:format] == 'mp4'
            o[:prepare_for_segmenting] = "hls"
            o[:caption_url] = caption_file_url
          end
        end
      end
      outputs
    end

    def encoding_settings
      outputs = @audio ? audio_outputs : video_outputs
      {
        input: input_url,
        outputs: outputs,
        notifications: notifications_url
      }
    end
  end
end
