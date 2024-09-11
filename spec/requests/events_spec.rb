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

    it 'sorts the events by start date' do
      create(:event, title: 'March', start_date: '01.03.2099'.to_date, end_date: '03.03.2099'.to_date)
      create(:event, title: 'January', start_date: '01.01.2099'.to_date, end_date: '03.01.2099'.to_date)
      get '/events'

      document = Nokogiri::HTML(response.body) # TODO: This feels like a hack
      table = document.search('table')
      # table.text is e.g. "MarchHamburgMarch 01, 2099JanuaryHamburgJanuary 01, 2099"
      expect(table.text).to start_with 'January'
    end

    context 'filters' do
      let!(:event_shag_hamburg) { create(:event, title: 'foo foo', city: 'Hamburg', dance_types: ['sankt_luis_shag']) }
      let!(:event_shag_berlin) { create(:event, title: 'bar bar', city: 'Berlin', dance_types: ['sankt_luis_shag']) }
      let!(:event_lindy_berlin) { create(:event, title: 'baz baz', city: 'Berlin', dance_types: %w[lindy_hop balboa]) }

      it 'filters by city' do
        get '/events', params: { city: 'Berlin' }
        expect(response.body).not_to include 'Hamburg'
        expect(response.body).to include 'bar bar'
        expect(response.body).to include 'baz baz'
      end

      it 'filters by dance type' do
        get '/events', params: { dance_type: 'lindy_hop' }

        expect(response.body).not_to include 'foo foo'
        expect(response.body).not_to include 'bar bar'
        expect(response.body).to include 'baz baz'
      end
    end
  end
end
