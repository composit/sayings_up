class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization
  layout 'application'

  helper_method :current_user

  private
    def current_user
      nil
    end
end
