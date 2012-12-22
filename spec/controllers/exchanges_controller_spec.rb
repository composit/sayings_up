require 'spec_helper'

describe ExchangesController do
  context 'GET' do
    it 'does something undetermined'
  end

  context 'GET/1' do
    it 'assigns the exchange' do
      exchange = stub
      sign_in_with_abilities( @controller, [[:read, exchange]] )
      Exchange.stub( :find ).with( '123' ) { exchange }
      get :show, id: 123, format: :json
      expect( assigns[:exchange] ).to eq exchange
    end
  end
  
  context 'POST' do
    let( :exchange ) { mock_model( Exchange ).as_null_object }
    let( :params ) { { exchange: { initial_values: { content: 'new exchange' } }, format: :json } }
    let!( :current_user ) { signed_in_user_with_abilities @controller, [[:create, Exchange]] }

    before :each do
      Exchange.stub( :new_with_initial_values ) { exchange }
    end

    it 'does not save if the user does not have the appropriate rights' do
      @controller.current_ability.cannot :create, Exchange
      expect { post :create, params }.to raise_error CanCan::AccessDenied
    end

    it 'assigns the current user' do
      Exchange.should_receive( :new_with_initial_values ).with hash_including user_id: current_user.id
      post :create, params
    end

    it 'saves the exchange' do
      exchange.should_receive :save!
      post :create, params
    end

    it 'responds with the exchange json'
  end
end
