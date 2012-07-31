class Admin::UsersController < AdminController
  respond_to :html, :js

  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_users_path
  end

  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    respond_with @user, location: admin_users_path
  end
  
  def search
    q = "%#{params[:search]}%"
    @users = User.where('first_name LIKE ? or last_name LIKE ? OR nickname LIKE ?', q, q, q)
  end
end
