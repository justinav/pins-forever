class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @user || @user = User.where("id=?",session[:user_id]).first
  end
  helper_method :current_user
end
