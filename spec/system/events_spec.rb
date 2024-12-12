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
end
