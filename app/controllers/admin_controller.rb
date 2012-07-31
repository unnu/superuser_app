class AdminController < ApplicationController
  before_filter :authenticate_admin!

  private
    def authenticate_admin!
      redirect_to root_path, :flash => {:error => t('not_authorized')} unless current_user.try(:admin?)
    end
end
