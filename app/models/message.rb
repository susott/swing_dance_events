class Message < ApplicationRecord
  validates :name, :body, :email, presence: true

  normalizes :name, with: ->(name) { name.squish }
  normalizes :email, with: ->(email) { email.squish.downcase }
end
