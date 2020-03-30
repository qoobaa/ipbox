class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def show
  end

  def tos
  end
end
