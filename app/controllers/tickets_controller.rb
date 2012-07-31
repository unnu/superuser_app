class TicketsController < UserApplicationController

  def index
    @user = current_user
    @tickets = current_user.tickets
  end
end
