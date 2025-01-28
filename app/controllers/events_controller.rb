class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path, notice: 'Success! Your event will be reviewed and published.'
    else
      flash[:alert] = 'Event could not be saved. Please double-check your input.'
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
end
