class ExchangesController < ApplicationController
  load_and_authorize_resource except: :create

  respond_to :html, only: :index
  respond_to :json

  def index
    @exchanges = @exchanges.map do |exchange|
      exchange.current_user = current_user
      exchange
    end
  end

  def show
    @exchange.current_user = current_user
  end

  def create
    @exchange = Exchange.new_with_initial_values params[:exchange][:initial_values].merge( { user_id: current_user.id } )
    authorize! :create, @exchange
    @exchange.save!
  end
end
