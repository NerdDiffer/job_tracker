class ChangeColumnNullForNotesUserId < ActiveRecord::Migration
  def up
    # values in user_id column of notes CANNOT be null
    change_column_null :notes, :user_id, false
  end

  def down
    # Do allow null values in this column
    change_column_null :notes, :user_id, true
  end
end
