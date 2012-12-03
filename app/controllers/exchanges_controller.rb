class ExchangesController < ApplicationController
  load_and_authorize_resource except: :create

  respond_to :html, only: :index
  respond_to :json

  def index
  end

  def show
    respond_with @exchange
  end

  def create
    @exchange = Exchange.new
    @exchange.initial_values = params[:exchange][:initial_values].merge( { user_id: current_user.id } )
    authorize! :create, @exchange
    @exchange.save
    respond_with @exchange
  end
=begin
  def index
    authorize! :read, Exchange
    @exchanges = Exchange.top_level.order_by( [:most_recent_entry_date, :desc] )
  end

  def new
    @exchange = Exchange.new
    @exchange.users << current_user
    authorize! :create, @exchange
  end

  def show
    authorize! :read, Exchange
    @exchange = Exchange.find( params[:id] )
  end

  def create
    if( params[:comment_id] )
      @exchange = Exchange.find( params[:exchange_id] ).entries.find( params[:entry_id] ).comments.find( params[:comment_id] ).new_exchange
    else
      @exchange = Exchange.new
      @exchange.users << current_user
    end
    authorize! :create, @exchange
    @exchange.save!
    entry = @exchange.entries.build( params[:exchange][:entry] )
    entry.user = current_user
    entry.save!
    redirect_to exchanges_path, notice: "Exchange was successfully created"
  end

  def update
    @exchange = Exchange.find( params[:id] )
    entry = @exchange.entries.build( params[:exchange][:entry] )
    entry.user = current_user
    entry.save!
    redirect_to @exchange, notice: "Response was successfully created"
  end
=end
end
