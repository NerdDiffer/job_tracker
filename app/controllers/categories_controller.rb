class CategoriesController < ApplicationController
  attr_reader :category

  before_action :set_category, only: :show

  def index
    @categories = Category.all
  end

  def show
    @companies = category.companies
  end

  private

  def set_category
    id = params[:id]
    @category = Category.find(id)
  end
end
