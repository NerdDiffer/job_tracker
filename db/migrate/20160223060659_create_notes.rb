class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :notable_id, index: true
      t.string :notable_type, default: 'Contact'
      t.text :contents

      t.timestamps null: false
    end
  end
end
