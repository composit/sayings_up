class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :json

  def create
    if @user.save
      respond_with @user
    else
      respond_with @user, status: :unprocessable_entity
    end
  end
end
