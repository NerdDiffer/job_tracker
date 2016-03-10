class AddProviderIdentitiesTable < ActiveRecord::Migration
  def change
    create_table 'provider_identities', force: :cascade do |t|
      t.string  :uid, null: false
      t.string  :provider, null: false
    end
  end
end
