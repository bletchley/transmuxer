module Transmuxer
  class NotificationsController < ApplicationController
    skip_before_action :verify_authenticity_token, raise: false

    def create
      if resource && resource.zencoder_job_id == params[:job][:id]
        handle_job_notification
      end

      head :ok
    end

    private

    def resource
      @resource ||= params[:resource].classify.constantize.where(id: params[:id]).first
    end

    def handle_job_notification
      resource.update_transmuxer_job(state: params[:job][:state], metadata: params[:input])
    end
  end
end
