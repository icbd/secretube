class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :container, foreign_key: true
      t.integer :status, comment: "same as container status"
      t.text :info
      t.integer :timestamp, limit: 8

    end
  end
end
