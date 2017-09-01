require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?
  
  before_action :it_mobile?, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { error: exception.message.to_s }, status: :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end

  def it_mobile?
    @mobile = Mobile::Check.call(request.user_agent)
  end

end
