class CreateJoinTableForCompaniesCategories < ActiveRecord::Migration
  def change
    join_table_opts = { table_name: 'companies_categories' }

    create_join_table :companies, :categories, join_table_opts do |t|
      t.index :company_id
      t.index :category_id
    end
  end
end
