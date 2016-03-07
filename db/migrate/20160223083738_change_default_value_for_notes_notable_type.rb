class ChangeDefaultValueForNotesNotableType < ActiveRecord::Migration
  def up
    change_column_default :notes, :notable_type, nil
  end

  def down
    change_column_default :notes, :notable_type, 'Contact'
  end
end
