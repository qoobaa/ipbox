class EntriesController < ApplicationController
  before_action :assign_user, :assign_projects, :assign_invoices
  before_action :assign_entries, only: [:index, :update_all, :destroy_all]

  def index
    @entry = @user.entries.build
    @update_entries_form = UpdateEntriesForm.new(entries: @entries)
    invoice_ids = @entries.distinct.except(:limit, :offset, :order).pluck(:invoice_id)
    @invoice = Invoice.find_by(id: invoice_ids.first) if invoice_ids.size == 1
  end

  def create
    @entry = @user.entries.create(entry_params)
  end

  def update
    @entry = @user.entries.find(params[:id])
    @entry.update(entry_params)
  end

  def update_all
    @update_entries_form = UpdateEntriesForm.new(update_entries_form_params)
    @update_entries_form.entries = @entries
    if @update_entries_form.valid?
      @update_entries_form.update_all
      redirect_to entries_path(q: params.fetch(:q, {}).to_unsafe_hash)
    end
  end

  def destroy_all
    @entries.destroy_all
    redirect_to entries_path(q: params.fetch(:q, {}).to_unsafe_hash)
  end

  def destroy
    @entry = @user.entries.find(params[:id])
    @entry.destroy
  end

  private

  def assign_user
    @user = current_user
  end

  def assign_projects
    @projects = @user.projects
  end

  def assign_invoices
    @invoices = @user.invoices
  end

  def assign_entries
    @q = @user.entries.ransack(params[:q])
    @entries =
      @q.result
        .includes(:invoice, :project)
        .page(params[:page])
        .order(:ended_at, :id)
  end

  def entry_params
    params.require(:entry).permit(:description, :type, :hours, :ended_at, :project_id, :exact)
  end

  def update_entries_form_params
    params.require(:update_entries_form).permit(:hours, :description, :type)
  end
end
