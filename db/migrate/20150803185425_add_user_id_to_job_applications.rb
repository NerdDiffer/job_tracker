class AddUserIdToJobApplications < ActiveRecord::Migration
  def change
    add_column :job_applications, :user_id, :string, :foreign_key => true
  end
end
