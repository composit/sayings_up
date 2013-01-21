class TaggingsController < ApplicationController
  load_and_authorize_resource :exchange
  load_and_authorize_resource :tagging, through: :exchange

  respond_to :json

  def create
    @tagging.user_id = current_user.id
    #TODO move into tagging model #save_or_return_duplicate!
    if( existing_tagging = Tagging.where( user_id: @tagging.user_id, exchange_id: @tagging.exchange_id, tag_id: @tagging.tag_id ).first )
      @tagging = existing_tagging
    else
      @tagging.save!
    end
  end

  def destroy
    @tagging.destroy
  end
end
