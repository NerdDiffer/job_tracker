class CopyInteractionsIntoNotes < ActiveRecord::Migration
  def up
    execute(copy_interactions_into_notes)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def copy_interactions_into_notes
    %q(INSERT INTO notes (notable_id, contents, created_at, updated_at)
       SELECT contact_id, notes, created_at, updated_at
       FROM interactions;)
  end
end
