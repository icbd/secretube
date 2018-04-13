class CreateBills < ActiveRecord::Migration[5.1]
  def change
    create_table :bills do |t|
      t.string :docker_id, null: false
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
