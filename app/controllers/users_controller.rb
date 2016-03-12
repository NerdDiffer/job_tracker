class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :set_user
  before_action :check_user

  def show
  end

  def destroy
    @user.destroy
    redirect_to user_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    id = current_user.id
    @user = User.find(id)
  end

  def check_user
    redirect_to(root_url) unless current_user?(@user)
  end
end
