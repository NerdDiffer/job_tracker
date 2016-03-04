class AddUniqueConstraintToCoverLettersAndPostings < ActiveRecord::Migration
  def up
    execute add_uniq_constraint(cover_letters)
    execute add_uniq_constraint(postings)
  end

  def down
    execute drop_uniq_constraint(postings)
    execute drop_uniq_constraint(cover_letters)
  end

  private

  def add_uniq_constraint(table_name)
    %Q(ALTER TABLE #{table_name}
       ADD CONSTRAINT uniq_job_application_id_on_#{table_name}
         UNIQUE (job_application_id);)
  end

  def drop_uniq_constraint(table_name)
    %Q(ALTER TABLE #{table_name}
       DROP CONSTRAINT uniq_job_application_id_on_#{table_name};)
  end

  def cover_letters
    'cover_letters'
  end

  def postings
    'postings'
  end
end
