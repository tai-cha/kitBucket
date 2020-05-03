class AddKptTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :kpt_token, :string
  end
end
