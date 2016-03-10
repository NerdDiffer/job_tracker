class AddRememberDigestColumnToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :remember_digest, :string
  end
end
