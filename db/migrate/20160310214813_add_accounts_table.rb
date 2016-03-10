class AddAccountsTable < ActiveRecord::Migration
  def change
    create_table 'accounts', force: :cascade do |t|
      t.string :name
      t.string :email, null: false, unique: true
      t.string :password_digest
    end
  end
end
