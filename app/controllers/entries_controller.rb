class EntriesController < ApplicationController
  def index
    @entry = Entry.new
    @unassigned_entries = Entry.by_year(2019).unassigned
    @q = Entry.ransack(params[:q])
    @projects = Project.all
    @entries =
      @q.result
        .includes(:invoice, :project)
        .order(ended_at: :asc)
        .by_year(2019)
        .page(params[:page])
  end

  def create
    @projects = Project.all
    @entry = Entry.create(entry_params)
  end

  def calculate
    CalculateHoursJob.perform_now
    redirect_to entries_path
  end

  def update
    @projects = Project.all
    @entry = Entry.find(params[:id])
    @entry.update(entry_params)
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
