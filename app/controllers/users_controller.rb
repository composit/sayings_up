class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :json

  def create
    if @user.save
      session[:user_id] = @user.id
      respond_with @user
    else
      respond_with @user, status: :unprocessable_entity
    end
  end

  def show
    respond_with @user
  end
end
