class EventsController < ApplicationController
  def show
  end

  def index
    @events = Event.all
  end
end
