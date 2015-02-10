module Transmuxer
  class NotificationsController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def create
      if resource && resource.zencoder_job_id == params[:job][:id]
        if params[:output] && params[:output][:event]
          handle_event_notification
        else
          handle_job_notification
        end
      end

      head :ok
    end

    private

    def resource
      @resource ||= params[:resource].classify.constantize.where(id: params[:id]).first
    end

    def handle_event_notification
      if params[:output][:state] != "failed"
        resource.update_playable params[:output][:label]
      end
    end

    def handle_job_notification
      resource.update_transmuxer_job(state: params[:job][:state], metadata: {duration_in_ms: params[:input][:duration_in_ms]})
    end
  end
end