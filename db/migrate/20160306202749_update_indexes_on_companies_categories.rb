class UpdateIndexesOnCompaniesCategories < ActiveRecord::Migration
  def change
    join_table = :companies_categories

    remove_index join_table, column: :company_id
    add_index join_table, [:company_id, :category_id], unique: true
  end
end
