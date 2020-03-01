class EntriesController < ApplicationController
  before_action :assign_user

  def index
    @entry = @user.entries.build
    @unassigned_entries = @user.entries.by_year(2019).unassigned
    @q = @user.entries.ransack(params[:q])
    @projects = @user.projects
    @entries =
      @q.result
        .includes(:invoice, :project)
        .order(ended_at: :asc)
        .by_year(2019)
        .page(params[:page])
    @update_entries_form = UpdateEntriesForm.new(entries: @entries)
  end

  def create
    @projects = @user.projects
    @entry = @user.entries.create(entry_params)
  end

  def update
    @projects = @user.projects
    @entry = @user.entries.find(params[:id])
    @entry.update(entry_params)
  end

  def update_all
    @projects = @user.projects
    @q = @user.entries.ransack(params[:q])
    @entries = @q.result.by_year(2019)
    @update_entries_form = UpdateEntriesForm.new(update_entries_form_params)
    @update_entries_form.entries = @entries
    if @update_entries_form.valid?
      @update_entries_form.update_all
      redirect_to entries_path(q: params.fetch(:q, {}).to_unsafe_hash)
    end
  end

  def destroy
    @entry = @user.entries.find(params[:id])
    @entry.destroy
  end

  private

  def assign_user
    @user = current_user
  end

  def entry_params
    params.require(:entry).permit(:description, :type, :hours, :ended_at, :project_id, :exact)
  end

  def update_entries_form_params
    params.require(:update_entries_form).permit(:hours, :description, :type)
  end
end
