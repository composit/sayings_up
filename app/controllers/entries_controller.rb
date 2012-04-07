class EntriesController < ApplicationController
  load_and_authorize_resource :exchange
  load_and_authorize_resource :entry, through: :exchange
  
  respond_to :json

  #def index
  #  if( @exchange = Exchange.where( _id: params[:exchange_id] ).first )
  #    @entries = @exchange.entries.accessible_by( current_ability )
  #  else
  #    @exchange = Exchange.new
  #  end
  #  authorize! :read, @exchange

  #  render json: @entries if @entries
  #end

=begin
  def new
  end

  def create
    @entry.user = current_user
    if( @entry.save )
      redirect_to entries_path, notice: "Entry was successfully created"
    else
      render "new"
    end
  end
=end
  def create
    @entry.save
    respond_with @exchange, @entry
  end
end
