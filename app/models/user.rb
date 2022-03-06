class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }

  has_many :contacts

  def self.encrypt_password(string)
    Digest::SHA2.hexdigest(string)
  end
end