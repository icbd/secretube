class Container < ApplicationRecord
  belongs_to :user

  validates :container_hash, presence: true

  enum status: {
      "running" => 1,
      "stopped" => 2,
      "removed" => 3,
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
