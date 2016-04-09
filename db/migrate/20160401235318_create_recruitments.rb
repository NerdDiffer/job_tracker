class CreateRecruitments < ActiveRecord::Migration
  def change
    create_table :recruitments do |t|
      t.integer :agency_id,  null: false
      t.integer :client_id,  null: false
      t.integer :recruit_id, null: false

      t.timestamps null: false
    end

    add_foreign_key(:recruitments, :companies, column: 'agency_id')
    add_foreign_key(:recruitments, :companies, column: 'client_id')
    add_foreign_key(:recruitments, :users, column: 'recruit_id')
    add_index(:recruitments, :recruit_id)
  end
end
