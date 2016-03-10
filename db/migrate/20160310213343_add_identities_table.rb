class AddIdentitiesTable < ActiveRecord::Migration
  def change
    create_table 'identities', force: :cascade do |t|
      t.references :user, foreign_key: true, null: false
      t.integer  :identifiable_id, null: false
      t.string   :identifiable_type, null: false
    end

    add_index 'identities', 'user_id', unique: true
    add_index 'identities', ['identifiable_type', 'identifiable_id'], unique: true
  end
end
