class Message < ApplicationRecord
  normalizes :name, with: ->(name) { name.squish }
  normalizes :email, with: ->(email) { email.strip.downcase }

  # warning: email validation is never perfect, but imho 'good enough' here
  validates :email, length: { in: 8..50 }, format: {
    with: URI::MailTo::EMAIL_REGEXP, message: 'please enter a valid email'
  }
  validates :body, length: { in: 30..2000 }
  validates :name, length: { in: 3..50 }
end
