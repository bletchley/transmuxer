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
        Video.create(zencoder_job_state: 'playback_ready')
        Video.create(zencoder_job_state: 'finished')

        match = Video.create(zencoder_job_state: 'failed')

        expect(Video.failed).to eq([match])
      end
    end

    describe '.ready' do
      it 'returns videos that can be streamed' do
        Video.create(zencoder_job_state: 'failed')
        Video.create(zencoder_job_state: 'processing')

        playback_ready = Video.create(zencoder_job_state: 'playback_ready')
        processed      = Video.create(zencoder_job_state: 'finished')

        expect(Video.ready).to eq([playback_ready, processed])
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
  end
end
