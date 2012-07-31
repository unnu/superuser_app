class CheckInController < ApplicationController
  
  rescue_from Ticket::TicketExpiredError, :with => :ticket_expired
  
  def create
    render(:text => 'Token mismtach!', :status => 400) and return unless params[:token] == 'CVFEZFZM6A7KaJ'
    
    @user = User.find_by_nickname(params[:nickname])
    unless @user
      redirect_to sign_up_url(nickname: params[:nickname], email: params[:email]) and return
    end
    
    @ticket = @user.current_ticket
    unless @ticket
      redirect_to me_url and return
    end
    
    @ticket.check_in! # raises TicketExpiredError
    render(:text => 'OK.', :status => 200)
  end
  
  private
    def ticket_expired
      redirect_to me_url
    end
end