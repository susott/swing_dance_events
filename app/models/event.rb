class Event < ApplicationRecord
  normalizes :website, with: -> website { website.strip.downcase }

  validates :title, length: { minimum: 4, maximum: 200 }, presence: true
  validates :dance_types, inclusion: { in: %w(lindy_hop balboa solo_jazz), message: "%{value} is not supported" }
  validates :start_date, :end_date, presence: true
  # TODO [:lindy, :collegiate_shag, :sankt_luis_shag, :blues, :balboa, west_coast, :charleston, :solo_jazz]
  validate :start_date_before_end_date
  # website should be an URI thingy
  # description can be empty

  private

  def start_date_before_end_date
    errors.add(:end_date, "Event can not end before it starts - please correct") if start_date.after?(end_date)
  end
end
