class EntriesController < ApplicationController
  def index
    @entry = Entry.new
    @unassigned_entries = Entry.by_year(2019).unassigned
    @q = Entry.ransack(params[:q])
    @entries =
      @q.result
        .includes(:invoice, :project)
        .order(ended_at: :asc)
        .by_year(2019)
  end

  def create
    @entry = Entry.create(entry_params)
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
    params.require(:entry).permit(:description, :type, :hours, :ended_at, :project_id, :exact)
  end
end
