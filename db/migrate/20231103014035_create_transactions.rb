class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :merchant, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.string :card_number
      t.string :transaction_date
      t.boolean :has_cbk
      t.decimal :transaction_amount, precision: 10, scale: 2

      t.timestamps
    end
    add_index :transactions, :card_number
    add_index :transactions, :transaction_date
  end
end
