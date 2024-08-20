require 'rails_helper'

RSpec.describe 'events/index.html.slim', type: :view do
  it 'show the filter form' do
    render
    expect(rendered).to match(/<input type="submit" name="commit"/)
    expect(rendered).to include('Filter by City')
    expect(rendered).to include('Filter by Dance')
  end

  it 'shows text if the event does not exist' do
    render
    expect(rendered).to include 'No events found. Please add some.'
  end

  it 'shows some details about an event' do
    @events = create_list(:event, 2)
    render

    expect(rendered).to include @events.first.title
    expect(rendered).to include @events.first.city
    expect(rendered).to include @events.first.start_date.strftime('%B %d, %Y')

    expect(rendered).to include @events.second.title
    expect(rendered).to include @events.second.city
    expect(rendered).to include @events.second.start_date.strftime('%B %d, %Y')
  end
end
