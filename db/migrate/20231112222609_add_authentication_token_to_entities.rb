class AddAuthenticationTokenToEntities < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :authentication_token, :string
  end
end
