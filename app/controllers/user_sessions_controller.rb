class UserSessionsController < ApplicationController
  skip_authorization_check
  respond_to :json

  def create
    @user = User.find_by_username params[:user_session][:username]
    if @user.authenticate params[:user_session][:password]
      session[:user_id] = @user.id
      respond_with @user
    else
      respond_with @user, status: :unprocessable_entity
    end
  end
end
