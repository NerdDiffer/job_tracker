class AddPermalinkColumnsToCompaniesAndContacts < ActiveRecord::Migration
  def change
    add_column :companies, :permalink, :string
    add_column :contacts, :permalink, :string
  end
end
