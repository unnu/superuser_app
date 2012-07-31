class UsersController < UserApplicationController
  
  respond_to :html
  
  before_filter :load_user
  
  def edit
  end

  def show
  end

  def update
    @user.attributes = params[:user]
    if @user.save
      flash[:info] = I18n.t('users.update.success')
    end
    respond_with @user
  end
  
  private
    def after_sign_out_path_for(resource_or_scope)
      redirect_to root_path
    end
  
    def load_user
      @user = current_user
    end
end
