class CreateLoans < ActiveRecord::Migration[8.0]
  def change
    create_table :loans do |t|
      t.references :borrower, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :borrow_date
      t.datetime :return_date
      t.datetime :returned_at

      t.timestamps
    end
  end
end
