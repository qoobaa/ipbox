class EntriesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @unassigned_entries = Entry.by_year(2019).unassigned
    @q = Entry.ransack(params[:q])
    @entries =
      @q.result
        .includes(:invoice)
        .order(committed_at: :asc)
        .by_year(2019)
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
