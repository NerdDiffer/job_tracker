class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.references  :contact, index: true, foreign_key: true

      t.string      :notes
      t.date        :approx_date
      t.integer     :medium # this gets pluralized as 'media'

      t.timestamps null: false
    end
  end
end
