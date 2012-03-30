class UserSessionsController < ApplicationController
  skip_authorization_check
  respond_to :json

  def create
    @user = User.where( username: params[:user_session][:username] ).first
    if @user && @user.authenticate( params[:user_session][:password] )
      session[:user_id] = @user.id
      respond_with @user
    else
      respond_with User.new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete :user_id
    respond_with true
  end
end
