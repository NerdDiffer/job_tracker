class AddNonJobApplicationIdConstraints < ActiveRecord::Migration
  def up
    # values in user_id column CANNOT be null
    change_column_null :cover_letters, :job_application_id, false
    change_column_null :postings, :job_application_id, false
  end

  def down
    # Do allow null values in these columns
    change_column_null :postings, :job_application_id, true
    change_column_null :cover_letters, :job_application_id, true
  end
end
