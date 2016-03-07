class DropInteractions < ActiveRecord::Migration
  def up
    drop_table :interactions
  end

  def down
    create_table :interactions
  end
end
