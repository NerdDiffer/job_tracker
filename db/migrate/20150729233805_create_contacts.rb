class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :company, index: true, foreign_key: true

      t.string :name
      t.string :title
      t.string :phone1
      t.string :phone2
      t.string :email

      t.timestamps null: false
    end
  end
end
