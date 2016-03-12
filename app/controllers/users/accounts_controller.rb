class Users::AccountsController < ApplicationController
  attr_reader :user, :identity, :account

  before_action :logged_in_user, only: [:edit, :update]
  before_action :load_user,      only: [:edit, :update]
  before_action :user_account,   only: [:edit, :update]

  def new
    @account  = Users::Account.new
  end

  def create
    new_user_identity_account

    if assign_and_save_user_identities!
      log_in(user)
      redirect_to user_path, notice: 'User account successfully created'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if account.update(account_params)
      redirect_to user_path, notice: 'User account successfully updated'
    else
      render :edit
    end
  end

  private

  def load_user
    id = current_user.id
    @user = User.find(id)
  end

  def user_account
    @account = user.identifiable if user.identifiable_account?
  end

  def account_params
    params.require(:users_account).permit(whitelisted_attr)
  end

  def whitelisted_attr
    [:name, :email, :password, :password_confirmation]
  end

  def new_user_identity_account
    @user     = User.new
    @identity = Users::Identity.new
    @account  = Users::Account.new(account_params)
  end

  def assign_and_save_user_identities!
    Users::Account.assign_and_save_user_identities!(account, identity, user)
  end
end
