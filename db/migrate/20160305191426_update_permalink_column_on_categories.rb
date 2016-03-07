class UpdatePermalinkColumnOnCategories < ActiveRecord::Migration
  def up
    save_permalink_on_all_categories
    # Values in permalink column CANNOT be null
    change_column_null :categories, :permalink, false
  end

  def down
    # Keep the data in permalink column.
    # Allow null values in this column.
    change_column_null :categories, :permalink, true
  end

  private

  def save_permalink_on_all_categories
    categories = Category.all
    categories.each do |cat|
      cat.permalink
      cat.save
    end
  end
end
