class EntriesController < ApplicationController
  load_and_authorize_resource :exchange
  load_and_authorize_resource :entry, through: :exchange
  
  respond_to :json

  def create
    @entry.user_id = current_user.id
    @exchange.save!
  end
end
