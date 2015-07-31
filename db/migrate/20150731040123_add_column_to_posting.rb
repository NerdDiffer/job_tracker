class AddColumnToPosting < ActiveRecord::Migration
  def change
    add_column :postings, :job_title, :string
  end
end
