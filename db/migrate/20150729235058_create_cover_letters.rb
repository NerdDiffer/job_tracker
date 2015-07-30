class CreateCoverLetters < ActiveRecord::Migration
  def change
    create_table :cover_letters do |t|
      t.references :job_application, index: true, foreign_key: true

      t.string     :content
      t.date       :sent_date

      t.timestamps null: false
    end
  end
end
