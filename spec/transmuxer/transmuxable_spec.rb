require 'spec_helper'
require 'active_record'

class TestableObject < ActiveRecord::Base
  include Transmuxer::Transmuxable
  attr_accessor :zencoder_job_state
end

module Transmuxer
  describe Transmuxable do
    before(:each) do
      Video.destroy_all
    end

    describe '.failed' do
      it 'returns videos that failed processing' do
        Video.create(zencoder_job_state: 'processing')
        Video.create(zencoder_job_state: 'finished')

        match = Video.create(zencoder_job_state: 'failed')

        expect(Video.failed).to eq([match])
      end
    end

    describe '.ready' do
      it 'returns videos that can be streamed' do
        Video.create(zencoder_job_state: 'failed')
        Video.create(zencoder_job_state: 'processing')

        processed = Video.create(zencoder_job_state: 'finished')

        # Outliers
        Video.create(zencoder_job_state: 'processing')
        Video.create(zencoder_job_state: 'failed')

        expect(Video.ready).to eq([processed])
      end
    end
  end

  describe '#transmux' do
    let(:video) { Video.create }

    context 'when transmuxer job fails to start' do
      let(:job) { double(:job, start: false, errors: "Oops!") }

      before do
        expect(Transmuxer::Job).to receive(:new) { job }
      end

      it do
        expect { video.transmux }.to raise_error(Transmuxer::JobNotStarted, "Oops!")
      end
    end

    it 'passes a passed in audio option to the transmuxer job' do
      job = double(:job, id: 1, start: true, errors: "Oops!")
      expect(Transmuxer::Job).to receive(:new).with(hash_including(audio: true)) { job }
      video.transmux(audio: true)
    end
  end

  describe '#ready?' do
    it 'returns true if video is finished' do
      video = Video.create(zencoder_job_state: 'finished')
      expect(video.ready?).to be true
    end

    it 'returns false if video is processing' do
      video = Video.create(zencoder_job_state: 'processing')
      expect(video.ready?).to be false
    end

    it 'returns false if video  failed' do
      video = Video.create(zencoder_job_state: 'failed')
      expect(video.ready?).to be false
    end
  end
end
