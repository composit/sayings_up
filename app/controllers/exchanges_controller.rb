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
    @exchange.save!
    respond_with @exchange
  end
end
