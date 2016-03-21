class CategoriesController < ApplicationController
  attr_reader :category

  before_action :logged_in_user
  before_action :set_category

  def show
    @companies = category.companies
  end

  private

  def set_category
    id = params[:id]
    @category = Category.find(id)
  end
end
