class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.references :job_application, index: true, foreign_key: true

      t.string     :content
      t.date       :posting_date
      t.string     :source

      t.timestamps null: false
    end
  end
end
