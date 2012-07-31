class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound, with: :render_404 unless Rails.env.development?
  
  private
    def render_404
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
end
