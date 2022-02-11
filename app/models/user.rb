class User < ApplicationRecord
  has_many :book_quotes
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

end
