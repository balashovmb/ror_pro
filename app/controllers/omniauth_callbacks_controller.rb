class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :common_auth
  
  def facebook
  end

  def twitter
  end

  private

  def common_auth
    @auth = request.env['omniauth.auth'] || new_auth
    @user = User.find_for_oauth(@auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: @auth.provider.capitalize if is_navigational_format?
    elsif @auth.provider
      session['provider'] = @auth.provider
      session['uid'] = @auth.uid
      flash[:notice] = 'Email is required to complete sign up'
      render 'omniauth_callbacks/set_email'
    else
      redirect_to new_user_registration_path
      flash[:alert] = "Could not authenticate you because invalid credentials"
    end
  end

  def new_auth
    OmniAuth::AuthHash.new(provider: session['provider'], uid: session['uid'], info: { email: params[:email] })
  end
end