require 'rails_helper'

RSpec.describe 'Events', type: :request do
  describe 'GET /show' do
    context 'if the event does not exist' do
      it 'returns a 404' do
        get '/events/-1'

        expect(response).to have_http_status(404)
      end
    end

    context 'if the event exists' do
      it 'returns http success and some info' do
        event = create(:event)
        get "/events/#{event.id}"

        expect(response).to have_http_status(:success)

        expect(response.body).to include 'Swing Dance Events'
        expect(response.body).to include event.title
        expect(response.body).to include event.description
        expect(response.body).to include event.start_date.strftime('%B %d, %Y')
        expect(response.body).to include event.end_date.strftime('%B %d, %Y')
      end
    end
  end

  describe 'GET /index' do
    it 'returns http success' do
      get '/events'
      expect(response).to have_http_status(:success)
    end

    it 'always show the filter form' do
      get '/events'
      expect(response.body).to match(/<input type="submit" name="commit"/)
      expect(response.body).to include('Filter by City')
      expect(response.body).to include('Filter by Dance')
    end

    it 'shows text if the event does not exist' do
      get '/events'
      expect(response.body).to include 'No events found. Please add some.'
    end

    it 'shows some infos about the events' do
      @events = create_list(:event, 2)
      get '/events'

      expect(response.body).to include @events.first.title
      expect(response.body).to include @events.first.city
      expect(response.body).to include @events.first.start_date.strftime('%B %d, %Y')

      expect(response.body).to include @events.second.title
      expect(response.body).to include @events.second.city
      expect(response.body).to include @events.second.start_date.strftime('%B %d, %Y')
    end

    xit 'filters are working'
  end
end
