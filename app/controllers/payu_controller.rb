class PayuController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    id = BlikCreateOrderJob.perform_now(ip: request.remote_ip, code: params[:code], email: params[:email])
    render json: {id: id}
  rescue BlikCreateOrderJob::Error => exception
    render json: {error: exception.message}
  end

  def show
    status = BlikRetrieveJob.perform_now(params[:id])
    render json: {status: status}
  rescue BlikRetrieveJob::Error => exception
    render json: {error: exception.message}
  end
end
