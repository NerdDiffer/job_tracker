class AddSourcesTable < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string     :name, null: false, default: 'other'
      t.timestamps null: false
    end

    add_index :sources, :name, unique: true
  end
end
