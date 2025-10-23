class AddFinanceTransactions < ActiveRecord::Migration[8.0]
  create_table :finance_transactions do |t|
    t.references :sender, foreign_key: { to_table: :users }
    t.references :recipient, foreign_key: { to_table: :users }
    t.decimal :amount, precision: 15, scale: 2, null: false
    t.string :transaction_type, null: false
    t.timestamps
  end
end
