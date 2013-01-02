class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization
  layout 'application'

  helper_method :current_user_session

  private
    def current_user
      @current_user ||= User.find( session[:user_id] ) if session[:user_id]
    end

    def current_user_session
      UserSession.new user: current_user if current_user
    end
end
