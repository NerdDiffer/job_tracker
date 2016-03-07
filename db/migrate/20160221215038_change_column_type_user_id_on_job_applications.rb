class ChangeColumnTypeUserIdOnJobApplications < ActiveRecord::Migration
  def up
    integer = 'integer USING CAST(user_id AS integer)'
    change_column :job_applications, :user_id, integer
  end

  def down
    change_column :job_applications, :user_id, :string
  end
end
