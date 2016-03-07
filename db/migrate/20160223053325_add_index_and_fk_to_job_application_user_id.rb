class AddIndexAndFkToJobApplicationUserId < ActiveRecord::Migration
  def change
    add_foreign_key :job_applications, :users
    add_index :job_applications, :user_id
  end
end
