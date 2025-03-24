require 'rails_helper'

RSpec.describe 'Events', type: :system do
  describe 'index page' do
    it 'shows the titel' do
      visit events_path
      expect(page).to have_content('Swing Dance Events')
    end

    it 'can filter events by country' do
      create(:event, title: 'Dance in France', country: 'France')
      create(:event, title: 'Second Event')
      visit events_path

      expect(page).to have_content('Dance in France')
      expect(page).to have_content('Second Event')

      fill_in('Country', with: 'France')
      click_button('Filter')

      expect(page).to have_content('Dance in France')
      expect(page).not_to have_content('Second Event')
    end

    it 'can filter events by city' do
      create(:event, title: 'Event in Bonn', city: 'Bonn')
      create(:event, title: 'Second Event')
      visit events_path

      expect(page).to have_content('Event in Bonn')
      expect(page).to have_content('Second Event')

      fill_in('City', with: 'Bonn')
      click_button('Filter')

      expect(page).to have_content('Event in Bonn')
      expect(page).not_to have_content('Second Event')
    end

    it 'can filter events by dance type' do
      create(:event, title: 'Bal and Lindy', dance_types: %w[balboa lindy_hop])
      create(:event, title: 'Bal and Shag', dance_types: %w[balboa shag])
      visit events_path

      select 'Lindy hop', from: 'dance_type'
      click_button('Filter')

      expect(page).to have_content('Bal and Lindy')
      expect(page).not_to have_content('Bal and Shag')
    end
  end

  describe 'show page' do
    it 'shows details about and event' do
      event = create(:event, title: 'Bal and Lindy', dance_types: %w[balboa lindy_hop])
      visit event_path(event)

      expect(page).to have_content('Bal and Lindy')
      expect(page).to have_content('Balboa, lindy hop')
      expect(page).to have_content(event.description)
      expect(page).to have_content(event.website)
      expect(page).to have_content(event.start_date.strftime('%B %d, %Y'))
      expect(page).to have_content(event.end_date.strftime('%B %d, %Y'))
    end
  end

  describe 'new page' do
    it 'can create a new event' do
      visit new_event_path

      expect(page).to have_content('Suggest a New Event')
      expect(page).to have_content('Name of the event')

      fill_in('Name of the event', with: 'Some Lindy festival')

      check('event_dance_types_lindy_hop')
      check('event_dance_types_balboa')

      select 'Germany', from: 'Country'
      fill_in('City', with: 'Berlin')

      select('13', from: 'event_start_date_3i')
      select('June', from: 'event_start_date_2i')
      select(Date.today.year + 1, from: 'event_start_date_1i')

      select('15', from: 'event_end_date_3i')
      select('June', from: 'event_end_date_2i')
      select(Date.today.year + 1, from: 'event_end_date_1i')

      fill_in('Description', with: 'The world famous test event is back')
      fill_in('Website', with: 'example.com')

      click_button('Submit Event')

      expect(page).to have_content('Success! Your event will be reviewed soon.')
      expect(page).to have_content('No events found. Please add some.')

      expect(Event.last.title).to eq('Some Lindy festival')
      expect(Event.last.published?).to be false
    end
  end
end
