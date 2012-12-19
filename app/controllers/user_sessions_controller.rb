class UserSessionsController < ApplicationController
  skip_authorization_check
  respond_to :json

  def create
    @user_session = UserSession.new params[:user_session]
    status = @user_session.authenticate! ? :created : :unprocessable_entity
    session[:user_id] = @user_session.user_id
    render status: status
  end

  def destroy
    session.delete :user_id
    respond_with true
  end
end
