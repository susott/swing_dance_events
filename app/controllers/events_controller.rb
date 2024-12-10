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
    @event = Event.published.find(params[:id])
  end

  def index
    @events = Events::Index.run!(
      city: params[:city],
      country: params[:country],
      dance_type: params[:dance_type]
    )
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :description, :dance_types, :start_date, :end_date, :website, :sign_up_start_date,
      :event_email, :country, :city, :parent_event_id
    )
  end

  def filter_params
    params.slice(:city, :country, :id, :dance_type)
  end
end
