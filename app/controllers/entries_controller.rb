class EntriesController < ApplicationController
  load_and_authorize_resource :exchange
  load_and_authorize_resource :entry, through: :exchange
  
  respond_to :json

  def create
    @entry.user = current_user
    @exchange.save!
    respond_with @exchange, @entry
  end
end
