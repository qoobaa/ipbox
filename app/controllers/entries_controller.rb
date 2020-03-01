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
    @update_entries_form = UpdateEntriesForm.new(entries: @entries)
  end

  def create
    @projects = Project.all
    @entry = Entry.create(entry_params)
  end

  def update
    @projects = Project.all
    @entry = Entry.find(params[:id])
    @entry.update(entry_params)
  end

  def update_all
    @projects = Project.all
    @q = Entry.ransack(params[:q])
    @entries = @q.result.by_year(2019)
    @update_entries_form = UpdateEntriesForm.new(update_entries_form_params)
    @update_entries_form.entries = @entries
    if @update_entries_form.valid?
      @update_entries_form.update_all
      redirect_to entries_path(q: params.fetch(:q, {}).to_unsafe_hash)
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
  end

  private

  def entry_params
    params.require(:entry).permit(:description, :type, :hours, :ended_at, :project_id, :exact)
  end

  def update_entries_form_params
    params.require(:update_entries_form).permit(:hours, :description, :type)
  end
end
