class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    render "show", layout: "landing"
  end

  def tos
  end
end
