class CreateBorrowers < ActiveRecord::Migration[8.0]
  def change
    create_table :borrowers do |t|
      t.string :card_number, null: false
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
