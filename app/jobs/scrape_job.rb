require 'net/http'

class ScrapeJob < ActiveJob::Base
  def self.perform
    main_page_nokogiri_doc = fetch_data
    links = collect_links(main_page_nokogiri_doc)
    event_files = visit_links(links) # This will hit all the subpages, so don't do that too often

    event_files.each do |document|
      extract_data_for_event(document)
    end
  end

  # Visit and get the html of the main page
  def self.fetch_data
    uri = URI.parse('https://www.swingplanit.com')
    response = Net::HTTP.get_response(uri)
    Nokogiri::HTML(response.body)
  end

  # From the saved index page, look for all festivals in supported countries and save the link to the details page
  def self.collect_links(main_page_nokogiri_doc)
    # - Find all div class="pins">Germany</div>
    listed_event = main_page_nokogiri_doc.search('.maintitles')
    listed_event.map do |event|
      country = event.search('.pins').text
      subpage_url = event.attribute_nodes.first.value if Event::SUPPORTED_COUNTRIES.include?(country)
      title = event.attribute_nodes[3].value.gsub(' - Teachers Confirmed', '')

      next if Event.upcoming.find_by(title: title)

      subpage_url
    end.compact
  end

  # Visit each detail page and save results
  def self.visit_links(links)
    # links = ["https://www.swingplanit.com/event/swingcake-tuebingen"]
    event_files = []
    links.each do |details_link|
      details_uri = URI.parse(details_link)
      response = Net::HTTP.get_response(details_uri)
      event_files << Nokogiri::HTML(response.body)
    end
    event_files
  end

  # From the details page of the event, scrape the data and store it as Event.
  def self.extract_data_for_event(document) # rubocop:disable Metrics/MethodLength
    event = Event.new
    details = document.search('li')
    start_date, end_date = details[0].text.delete_prefix("\nWhen? ").split(' - ')

    event.start_date = start_date.to_date
    event.end_date = end_date.to_date
    event.country = details[1].text.delete_prefix('Country: ')
    event.city = details[2].text.delete_prefix('Town: ')
    event.website = details[3].text.delete_prefix('Website: ').delete_suffix('\n')
    dance_styles = details[4].text.delete_prefix('Styles: ').split(', ')
    event.dance_types = dance_styles.map { |dance_type| dance_type.parameterize.underscore }

    event.title = document.title
    event.description = document.search('.scroll-pane2')
                                .text
                                .delete_prefix("\n\t\t\t\t\t\t\t")
                                .delete_suffix("\n\t\t\t\t\t\t")

    begin event.save!
          'all good'
    rescue ActiveRecord::RecordInvalid
      debugger unless Rails.env.production? # rubocop:disable Lint/Debugger
    end
  end
end
