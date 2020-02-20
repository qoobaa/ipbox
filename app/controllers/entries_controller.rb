class EntriesController < ApplicationController
  def index
    @unassigned_entries = Entry.by_year(2019).unassigned
    @q = Entry.ransack(params[:q])
    @entries =
      @q.result
        .includes(:invoice, :repository)
        .order(committed_at: :asc)
        .by_year(2019)
  end

  def calculate
    CalculateHoursJob.perform_now
    redirect_to entries_path
  end

  def update
    @entry = Entry.find(params[:id])
    @entry.update!(entry_params)
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
  end

  private

  def entry_params
    params.require(:entry).permit(:type, :hours, :exact)
  end
end
