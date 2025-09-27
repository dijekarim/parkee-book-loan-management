class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.integer :stock, default: 0, null: false

      t.timestamps
    end
  end
end
