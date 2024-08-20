require 'rails_helper'

RSpec.describe 'events/show.html.slim', type: :view do
  it 'shows some text if the event does not exist' do
    render
    expect(rendered).to match 'Sorry. This event can not be found.'
  end

  it 'shows details about an event' do
    event = 
  end
end
