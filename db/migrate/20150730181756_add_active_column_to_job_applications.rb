class AddActiveColumnToJobApplications < ActiveRecord::Migration
  def change
    add_column :job_applications, :active, :boolean, :default => true
  end
end
