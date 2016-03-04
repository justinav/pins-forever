class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @user || @user = User.where("id=?",session[:user_id]).first
  end
  helper_method :current_user

  def require_login
    if current_user.nil?
      redirect_to login_path
    end
  end
end
