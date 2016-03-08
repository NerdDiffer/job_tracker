class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user,       only: [:show, :edit, :update, :destroy]
  before_action :check_user,     only: [:show, :edit, :update, :destroy]

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      redirect_to user_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to user_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to user_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    id = current_user.id
    @user = User.find(id)
  end

  def user_params
    params.require(:user).permit(whitelisted_attr)
  end

  def whitelisted_attr
    [:first_name, :last_name, :email, :password, :password_confirmation]
  end

  def check_user
    redirect_to(root_url) unless current_user?(@user)
  end
end
