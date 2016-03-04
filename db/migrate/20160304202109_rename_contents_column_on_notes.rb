class RenameContentsColumnOnNotes < ActiveRecord::Migration
  def change
    rename_column :notes, :contents, :content
  end
end
