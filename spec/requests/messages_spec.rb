require 'rails_helper'

RSpec.describe '/messages', type: :request do
  let(:valid_attributes) { { name: 'Micky Mouse', body: 'some text', email: 'micky@example.com' } }
  let(:invalid_attributes) { { name: '', email: 'micky@example.com' } }

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_message_url
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Message' do
        expect do
          post messages_url, params: { message: valid_attributes }
        end.to change(Message, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Message' do
        expect do
          post messages_url, params: { message: invalid_attributes }
        end.to change(Message, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post messages_url, params: { message: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
