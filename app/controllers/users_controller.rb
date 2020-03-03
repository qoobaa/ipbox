class UsersController < ApplicationController
  before_action :assign_user

  def show
  end

  private

  def assign_user
    @user = current_user
  end
end
