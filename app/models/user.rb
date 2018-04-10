class User < ApplicationRecord
  has_secure_password
  before_save :downcase_email

  validates :email, presence: true,
            format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i},
            uniqueness: {case_sensitive: false}

  validates :password, presence: true

  private

  def downcase_email
    self.email = email.downcase
  end
end