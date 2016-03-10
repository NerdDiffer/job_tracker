class AddUniqueIndexesToAccountsProviderIds < ActiveRecord::Migration
  def change
    add_index :accounts, :email, unique: true
    add_index :provider_identities, [:provider, :uid], unique: true
  end
end
