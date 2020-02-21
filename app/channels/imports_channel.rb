class ImportsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "imports-#{params[:project_id]}"
  end
end
