class StaticController < ApplicationController
  def imprint; end

  def about; end

  def contact
    # use command pattern thingy?
    return if params[:do_not_use].present?

    debugger
    name = params[:name]
    body = params[:body]

    # TODO
    # Create a contact message with name, body and email
    # hide the 'do not use' field
    # make the form look acceptable

  end
end
