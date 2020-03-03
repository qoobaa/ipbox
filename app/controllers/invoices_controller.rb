class InvoicesController < ApplicationController
  before_action :assign_user, :assign_invoice

  def index
    @invoices = @user.invoices.order(from: :asc)
  end

  def show
    @invoice = @user.invoices.find(params[:id])
    @projects = @user.projects
    @entries_by_day = @invoice.entries.order(:ended_at, :id).group_by(&:day)
  end

  def create
    @invoice = @user.invoices.build(invoice_params)
    if @invoice.save
      redirect_to invoices_path
    end
  end

  def update
    @invoice = @user.invoices.find(params[:id])
    if @invoice.update(invoice_params)
      redirect_to invoices_path
    end
  end

  def destroy
    @invoice = @user.invoices.find(params[:id])
    @invoice.destroy
    redirect_to invoices_path
  end

  private

  def assign_user
    @user = current_user
  end

  def assign_invoice
    @invoice = @user.invoices.build
    last_invoice = @user.invoices.order(to: :asc).last
    @invoice.from = last_invoice&.to&.advance(days: 1) || "2019-01-01".to_date
    @invoice.to = @invoice.from.end_of_month
  end

  def invoice_params
    params.require(:invoice).permit(:number, :from, :to, :hours)
  end
end
