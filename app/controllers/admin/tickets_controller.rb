class Admin::TicketsController < AdminController
  respond_to :html, :js
  
  before_filter :load_user
  
  def show
    @ticket = @user.tickets.find(params[:id])
  end
  
  def new
    @ticket = @user.tickets.new
  end
  
  def edit
    @ticket = @user.tickets.find(params[:id])
  end
  
  def update
    @ticket = @user.tickets.find(params[:id])
    @ticket.update_attributes(params.slice(:checkins_left, :recurring))
    
    render :show
  end

  def create
    @ticket = Ticket.new_from_params(params[:ticket])

    if @ticket.save
      flash[:info] = I18n.t('admin.tickets.create.success')
      redirect_to admin_user_path(@user)
    else
      flash[:error] = I18n.t('admin.tickets.create.error')
      render :new
    end
  end

  def destroy
    Ticket.find(params[:id]).destroy
    flash[:info] = I18n.t('admin.tickets.destroy.success')
    redirect_to :back
  end
  
  private
    def load_user
      @user = User.find(params[:user_id]) if params[:user_id]
    end
end
