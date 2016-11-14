require 'spec_helper'
require 'active_record'

module Transmuxer
  describe Job do
    describe '#start' do
      context 'when job is audio type' do
        it 'uses the correct encoding settings' do
          params = {
            input_url: 'abc123',
            output_store_path: 'abc123',
            notifications_url: 'abc123',
            caption_file_url: 'abc123',
            audio: true
          }
          zencoder_job = double(:job, success?: true)
          transmuxer_job = Transmuxer::Job.new(params)
          expected_hash = hash_including(outputs: transmuxer_job.send(:audio_outputs))
          expect(Zencoder::Job).to receive(:create).with(expected_hash) { zencoder_job }
          transmuxer_job.start
        end
      end

      context 'when job is not audio type' do
        it 'uses the correct encoding settings' do
          params = {
            input_url: 'abc123',
            output_store_path: 'abc123',
            notifications_url: 'abc123',
            caption_file_url: 'abc123',
          }
          zencoder_job = double(:job, success?: true)
          transmuxer_job = Transmuxer::Job.new(params)
          expected_hash = hash_including(outputs: transmuxer_job.send(:video_outputs))
          expect(Zencoder::Job).to receive(:create).with(expected_hash) { zencoder_job }
          transmuxer_job.start
        end
      end
    end
  end
end
