class AddCoinToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :coin, :integer, limit: 8, default: 0, null: false
  end
end
