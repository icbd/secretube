class CreateContainers < ActiveRecord::Migration[5.1]
  def change
    create_table :containers do |t|
      t.string :container_id, null: false, comment: "container hash key with full length"
      t.belongs_to :user, foreign_key: true

      t.string :host
      t.integer :port
      t.string :encryption
      t.string :password
      t.string :remark

      t.integer :status, comment: "running stopped removed"


      t.timestamps
    end
  end
end
