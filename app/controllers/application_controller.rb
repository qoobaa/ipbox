class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:company_name, :address, :postal_code, :city, :vatin, :stripe_payment_intent_id, :einvoice_accepted, :tos_accepted])
  end
end
