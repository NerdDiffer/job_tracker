class ReplacePostingsSourceData < ActiveRecord::Migration
  def up
    execute(populate_sources_table)
    execute(replace_source_for_postings)
    remove_column(:postings, :source)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def populate_sources_table
    %q(INSERT INTO sources (name, created_at, updated_at)
       SELECT DISTINCT ON (source) source, created_at, updated_at
       FROM postings;)
  end

  def replace_source_for_postings
    %q(UPDATE postings
       SET source_id = (
         SELECT id FROM sources WHERE name = postings.source
      );)
  end
end
