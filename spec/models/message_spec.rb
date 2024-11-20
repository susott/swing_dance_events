require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'messages can be created' do
    message = build(:message)

    expect(message).to be_valid
  end

  it 'messages need a body' do
    message = build(:message, body: nil)

    expect(message).to be_invalid
  end

  it 'messages body needs to have a min of 15 characters' do
    message = build(:message, body: 'too short')

    expect(message).to be_invalid
  end

  it 'messages need an email' do
    message = build(:message, email: 'notanemail')

    expect(message).to be_invalid
  end
end
