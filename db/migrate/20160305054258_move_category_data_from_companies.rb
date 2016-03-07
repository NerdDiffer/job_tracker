class MoveCategoryDataFromCompanies < ActiveRecord::Migration
  def up
    execute(populate_categories_table)
    execute(populate_companies_categories_join_table)
    remove_column :companies, :category, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def populate_categories_table
    %q(INSERT INTO categories (name)
       SELECT DISTINCT ON (category) category FROM companies;)
  end

  def populate_companies_categories_join_table
    %q(INSERT INTO companies_categories (company_id, category_id)
       SELECT companies.id AS company_id,
              categories.id AS category_id
       FROM companies JOIN categories ON companies.category = categories.name;)
  end
end
