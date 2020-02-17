class LogsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @q = Entry.ransack(params[:q])
    @entries =
      @q.result
        .order(committed_at: :asc)
        .where("committed_at >= '2019-01-01'")
        .where("committed_at <= '2019-12-31'")
  end

  def create
    attributes = request.raw_post.lines.map { |line| [:committed_at, :message].zip(line.chomp.split(" ", 2)).to_h }
    Entry.create!(attributes)
  end

  def update
    @entry = Entry.find(params[:id])
    @entry.update!(entry_params)
  end

  private

  def entry_params
    params.require(:entry).permit(:type, :duration)
  end
end
