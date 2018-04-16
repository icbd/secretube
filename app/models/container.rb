class Container < ApplicationRecord
  belongs_to :user

  validates :container_id, presence: true

  enum status: {
      "running" => 1,
      "stopped" => 2,
      "removed" => 3,
  }
end
