class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
