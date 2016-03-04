class AddNonNullUserIdConstraints < ActiveRecord::Migration
  def up
    # values in user_id column CANNOT be null
    change_column_null :contacts, :user_id, false
    change_column_null :job_applications, :user_id, false
  end

  def down
    # Do allow null values in these columns
    change_column_null :job_applications, :user_id, true
    change_column_null :contacts, :user_id, true
  end
end
