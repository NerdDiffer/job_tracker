class RemoveIndexFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, column: :email
  end
end
