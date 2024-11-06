require 'rails_helper'

RSpec.describe Event do
  it 'events can be created' do
    event = build(:event)

    expect(event).to be_valid
  end

  it 'events end_date can not be before start_date' do
    event = build(:event, start_date: '14 Jun 2025'.to_datetime, end_date: '12 Jun 2025'.to_datetime)

    expect(event).to be_invalid
  end
end
