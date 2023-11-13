class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :type
      t.string :user_name
      t.string :password
      t.string :name
      t.decimal :current_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
