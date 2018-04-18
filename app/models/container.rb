class Container < ApplicationRecord
  belongs_to :user
  has_many :histories

  validates :container_hash, presence: true

  enum status: {
      created: 1,
      running: 2,
      stopped: 3,
      removed: 4,
  }

  def qr_url
    require 'base64'
    base = Base64.encode64 "#{encryption}:#{password}@#{host}:#{port}"

    "ss://#{base.delete("=").delete("\n")}#Secretube"
  end

  def short_id
    container_hash[0, 12]
  end
end
