class ImportsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "imports-#{params[:repository_id]}"
  end
end
