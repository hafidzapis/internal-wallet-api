class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.string :type
      t.string :user_name
      t.string :password
      t.string :name

      t.timestamps
    end
  end
end
