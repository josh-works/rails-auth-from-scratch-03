class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  has_many :book_quotes
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  before_save :downcase_email
  
  has_secure_password
  
  def confirmed?
    confirmed_at.present?
  end
  
  def unconfirmed?
    !confirmed?
  end
  
  def confirm!
    update_columns(confirmed_at: Time.now)
  end
  
  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end
  
  def downcase_email
    self.email = email.downcase
  end
end
