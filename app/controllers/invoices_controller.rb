class InvoicesController < ApplicationController
  before_action :assign_user

  def index
    @invoices = @user.invoices.order(from: :asc)
  end

  def show
    @invoice = @user.invoices.find(params[:id])
    @projects = @user.projects
  end

  def new
    @invoice = @user.invoices.build
    @last_invoice = @user.invoices.order(from: :asc).last
  end

  def create
    @invoice = @user.invoices.new(invoice_params)
    if @invoice.save
      redirect_to invoices_path
    end
  end

  private

  def assign_user
    @user = current_user
  end

  def invoice_params
    params.require(:invoice).permit(:number, :from, :to, :hours)
  end
end
