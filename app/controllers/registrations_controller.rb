class RegistrationsController < Devise::RegistrationsController
  
  before_filter :initialize_prefill
  
  def new
    @prefill[:nickname] = params[:nickname] if params[:nickname].present?
    @prefill[:email] = params[:email] if params[:email].present?
    
    resource = build_resource(@prefill)
    respond_with resource
  end
  
  private
    def initialize_prefill
      @prefill = {}
    end
end