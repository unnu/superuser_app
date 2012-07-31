class PasswordsController < UserApplicationController
  skip_before_filter :authenticate_user!, only: [:new]
  
  def edit
    @user = current_user
  end

  def update
   @user = current_user

    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to user_path(current_user), :flash => {:info => t('passwords.edit.success')}
    else
      flash[:error] = t('passwords.edit.error')
      render :edit
    end
  end
  
  def new
    @user = User.find_by_email(params[:email])
    @user.send_reset_password_instructions if @user
    flash[:info] = t('passwords.new.recover')
    redirect_to root_path
  end
end