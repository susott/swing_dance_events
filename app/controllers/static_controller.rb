class StaticController < ApplicationController
  def about; end

  # this is a message create action!
  def create_contact_form
    return if params[:do_not_use].present?

    # debugger
    name = params[:name]
    body = params[:body]

    # TODO
    # Create a contact message with name, body and email
    # hide the 'do not use' field
    # make the form look acceptable
  end
end
