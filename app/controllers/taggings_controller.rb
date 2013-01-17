class TaggingsController < ApplicationController
  load_and_authorize_resource :exchange
  load_and_authorize_resource :tagging, through: :exchange

  respond_to :json

  def create
    @tagging.user_id = current_user.id
    @tagging.save!
  end
end
