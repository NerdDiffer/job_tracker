class AddConstraintToNotesNotable < ActiveRecord::Migration
  def up
    # values in these columns of notes CANNOT be null
    change_column_null :notes, :notable_id, false
    change_column_null :notes, :notable_type, false
  end

  def down
    # Do allow null values in these columns
    change_column_null :notes, :notable_type, true
    change_column_null :notes, :notable_id, true
  end
end
