class UserDecorator < ApplicationDecorator
  delegate :type

  def account?
    type == account
  end

  private

  def account
    'Users::Account'
  end
end
