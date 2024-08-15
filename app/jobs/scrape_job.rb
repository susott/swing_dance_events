class ScrapeJob < ActiveJob::Base
  def self.perform
    # fetch_data # This will hit the page, so don't do that too often
    # links = collect_links
    # visit_links(links) # This will hit all the subpages, so don't do that too often

    Dir.glob('app/jobs/scrape_results/*.html') do |filename|
      extract_data_for_event(File.read(filename))
    end
  end

  # Visit and safe the html of the details page
  def self.fetch_data
    response = HTTParty.get(
      'https://www.swingplanit.com', {
        headers: {
          'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, ' \
                          'like Gecko) Chrome/109.0.0.0 Safari/537.36'
        }
      }
    )

    document = Nokogiri::HTML(response.body)
    File.write('app/jobs/scrape_result.html', document)
  end

  # From the safed index page, look for all festivals in Germany and save the link to the details page
  def self.collect_links
    data = File.read('app/jobs/scrape_result.html')
    document = Nokogiri::HTML(data)

    # - Find all div class="pins">Germany</div>
    listed_event = document.search('.maintitles')
    listed_event.map do |event|
      country = event.search('.pins').text
      event.attribute_nodes.first.value if Event::SUPPORTED_COUNTRIES.include?(country)
    end.compact
  end

  # Visit each detail page and save results
  def self.visit_links(links)
    # links = ["https://www.swingplanit.com/event/swingcake-tuebingen"]
    links.each do |details_page|
      response = HTTParty.get(details_page, {
                                headers: {
                                  'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' \
                                                  '(KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
                                }
                              })
      document = Nokogiri::HTML(response.body)

      uri = URI(details_page)
      File.write("app/jobs/scrape_results/#{uri.path.gsub('/', '')}.html", document)
    end
  end

  # From the saved details page of the event, scrape the data and store it as Event.
  def self.extract_data_for_event(event_file) # rubocop:disable Metrics/MethodLength
    document = Nokogiri::HTML(event_file)

    event = Event.new
    details = document.search('li')
    start_date, end_date = details[0].text.delete_prefix("\nWhen? ").split(' - ')

    event.start_date = start_date.to_date
    event.end_date = end_date.to_date
    event.country = details[1].text.delete_prefix("\nCountry: ")
    event.city = details[2].text.delete_prefix("\nTown: ")
    event.website = details[3].text.delete_prefix("\nWebsite: ").delete_suffix("\n")
    dance_styles = details[4].text.delete_prefix("\nStyles: ").split(', ')
    event.dance_types = dance_styles.map { |dance_type| dance_type.parameterize.underscore }

    event.title = document.title
    event.description = document.search('.scroll-pane2')
                                .text
                                .delete_prefix("\n\t\t\t\t\t\t\t")
                                .delete_suffix("\n\t\t\t\t\t\t")

    begin event.save!
          'all good'
    rescue ActiveRecord::RecordInvalid
      debugger # rubocop:disable Lint/Debugger
    end
  end
end
