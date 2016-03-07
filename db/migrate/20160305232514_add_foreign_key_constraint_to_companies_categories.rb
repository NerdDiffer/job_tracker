class AddForeignKeyConstraintToCompaniesCategories < ActiveRecord::Migration
  def change
    join_table = :companies_categories
    add_foreign_key join_table, :companies
    add_foreign_key join_table, :categories
  end
end
