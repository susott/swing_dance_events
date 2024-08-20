require 'rails_helper'

RSpec.describe 'events/show.html.slim', type: :view do
  it 'shows some text if the event does not exist' do
    render
    expect(rendered).to match 'Sorry. This event can not be found.'
  end

  it 'shows some details about an event' do
    @event = build(:event)
    render

    expect(rendered).to match @event.title
    expect(rendered).to match @event.description
    expect(rendered).to match @event.start_date.strftime('%B %d, %Y')
    expect(rendered).to match @event.end_date.strftime('%B %d, %Y')
  end
end
