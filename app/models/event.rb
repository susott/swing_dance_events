class Event < ApplicationRecord
  normalizes :website, with: -> website { website.strip.downcase }

  DANCE_TYPES = %w(lindy_hop balboa solo_jazz, collegiate_shag, sankt_luis_shag, blues, west_coast, charleston, solo_jazz boogie_woogie).freeze

  validates :title, length: { minimum: 4, maximum: 200 }, presence: true
  validates :dance_types, inclusion: { in: DANCE_TYPES, message: "%{value} is not supported" }
  validates :start_date, :end_date, presence: true
  validate :start_date_before_end_date

  scope :upcoming, -> { where("end_date > ?", Date.today) }
  scope :past, -> { where("end_date <= ?", Date.today) }

  scope :filter_by_city, -> (city) { where(city: city) }
  scope :filter_by_country, -> (country) { where(country: country) }
  # scope :filter_by_dance_types, -> ()

  # website should be an URI thingy
  # description can be empty

  # currently only used for comand line
  def upcoming?
    end_date > Date.today
  end

  private

  def start_date_before_end_date
    errors.add(:end_date, "Event can not end before it starts.") if start_date.after?(end_date)
  end
end
