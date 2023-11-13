class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :type
      t.decimal :amount, precision: 10, scale: 2
      t.references :source_wallet, null: false, foreign_key: { to_table: :wallets }
      t.references :target_wallet, null: false, foreign_key: { to_table: :wallets }
      t.references :wallet, null: false, foreign_key: true
      t.timestamps
    end
  end
end
