class UpdateDdlForCategories < ActiveRecord::Migration
  def change
    add_column :categories, :permalink, :string
    add_index :categories, :permalink, unique: true
    remove_index :categories, :name
  end
end
