class Event < ApplicationRecord
  DANCE_TYPES = %w[lindy_hop balboa blues west_coast charleston boogie_woogie shag jazz].freeze
  SUPPORTED_COUNTRIES = [
    'Albania', 'Andorra', 'Austria', 'Belgium', 'Bosnia and Herzegovina', 'Bulgaria', 'Croatia',
    'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary',
    'Iceland', 'Ireland', 'Italy', 'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta',
    'Moldova', 'Monaco', 'Montenegro', 'Netherlands', 'Norway', 'Poland', 'Portugal', 'Romania',
    'San Marino', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'United Kingdom'
  ].freeze

  normalizes :website, with: ->(website) { website.squish.downcase }
  normalizes :city, :title, :country, with: lambda(&:squish)

  validates :title, length: { minimum: 4, maximum: 200 }, presence: true
  validates :start_date, :end_date, :description, presence: true
  validates :country, inclusion: { in: SUPPORTED_COUNTRIES }
  validates :city, presence: true
  validates :website, presence: true

  validate :start_date_before_end_date
  validate :supported_dance_types

  scope :upcoming, -> { where('end_date > ?', Date.today) }
  scope :past, -> { where('end_date <= ?', Date.today) }
  scope :published, -> { where(published: true) }

  scope :filter_by_city, ->(city) { where(city:) }
  scope :filter_by_country, ->(country) { where(country:) }
  scope :filter_by_dance_types, ->(dance) { where('DANCE_TYPES && array[?]', dance) }

  def upcoming?
    end_date > Date.today
  end

  private

  def start_date_before_end_date
    errors.add(:end_date, 'Event can not end before it starts.') if start_date&.after?(end_date)
  end

  def supported_dance_types
    errors.add(:dance_types, 'Unsupported dance type') if (dance_types - Event::DANCE_TYPES).present?
  end
end
