class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(filter_params[:id])
  rescue ActiveRecord::RecordNotFound
    render html: helpers.tag.strong('This page does not exist')
  end

  def index
    # see https://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/
    @events = Event.upcoming.where(nil) # creates an anonymous scope
    @events = @events.filter_by_city(filter_params[:city]) if params[:city].present?
    @events = @events.filter_by_country(filter_params[:country]) if params[:country].present?
    @events = @events.filter_by_dance_types(filter_params[:dance_type]) if params[:dance_type].present?
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :description, :dance_types, :start_date, :end_date, :website, :sign_up_start_date,
      :event_email, :country, :city
    )
  end

  def filter_params
    params.slice(:city, :country, :id, :dance_type)
  end
end
