module Events
  class Index < ActiveInteraction::Base
    string :city, default: nil
    string :country, default: nil
    string :dance_type, default: nil

    def execute
      # see https://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/
      @events = Event.upcoming.where(nil).order(:start_date) # creates an anonymous scope
      @events = @events.filter_by_city(city) if city.present?
      @events = @events.filter_by_country(country) if country.present?
      @events = @events.filter_by_dance_types(dance_type) if dance_type.present?
      @events
    end
  end
end
