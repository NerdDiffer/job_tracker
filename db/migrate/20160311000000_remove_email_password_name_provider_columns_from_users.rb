class RemoveEmailPasswordNameProviderColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :email, :string
    remove_column :users, :password_digest, :string
    remove_column :users, :remember_digest, :string
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
