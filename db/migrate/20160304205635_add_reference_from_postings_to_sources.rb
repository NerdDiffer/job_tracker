class AddReferenceFromPostingsToSources < ActiveRecord::Migration
  def change
    add_reference :postings, :source, index: true, foreign_key: true
  end
end
