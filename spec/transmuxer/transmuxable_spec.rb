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

    describe '.processed' do
      it 'returns videos that have finished processing' do
        Video.create(zencoder_job_state: 'failed')
        Video.create(zencoder_job_state: 'processing')

        match = Video.create(zencoder_job_state: 'finished')

        expect(Video.processed).to eq([match])
      end
    end
  end
end
