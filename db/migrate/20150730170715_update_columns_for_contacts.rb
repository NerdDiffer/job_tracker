class UpdateColumnsForContacts < ActiveRecord::Migration
  def change
    change_table :contacts do |t|
      t.rename :name, :first_name
      t.string :last_name

      t.rename :phone1, :phone_office
      t.rename :phone2, :phone_mobile
    end
  end
end
