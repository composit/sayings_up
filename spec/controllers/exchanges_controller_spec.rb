require 'spec_helper'

describe ExchangesController do
  context 'GET' do
    it 'does something undetermined'
  end

  context 'GET/1' do
    it 'assigns the exchange' do
      exchange = stub
      ability = Object.new.extend CanCan::Ability
      ability.can :read, exchange
      @controller.stub( :current_ability ) { ability }
      Exchange.stub( :find ).with( '123' ) { exchange }
      get :show, id: 123
      expect( assigns[:exchange] ).to eq exchange
    end
  end
  
  context 'POST' do
    let( :current_user ) { mock_model User }
    let( :exchange ) { mock_model( Exchange ).as_null_object }
    let( :parent_exchange ) { mock_model Exchange }
    let( :parent_entry ) { mock_model Entry, exchange: parent_exchange }
    let( :parent_comment ) { mock_model Comment, entry: parent_entry }
    let( :ability ) { Object.new }
    let( :params ) { { exchange: { initial_values: { parent_comment_id: parent_comment.id, parent_entry_id: parent_entry.id, parent_exchange_id: parent_exchange.id, content: 'new exchange' } }, format: :json } }

    before :each do
      @controller.stub( :current_user ) { current_user }
      ability.extend CanCan::Ability
      @controller.stub( :current_ability ) { ability }
      ability.can :create, Exchange
      Exchange.should_receive( :new ) { exchange }
    end

    it 'does not save if the user does not have the appropriate rights' do
      bad_ability = Object.new
      bad_ability.extend CanCan::Ability
      @controller.stub( :current_ability ) { bad_ability }
      ability.cannot :create, Exchange
      expect { post :create, params }.to raise_error CanCan::AccessDenied
    end

    it 'assigns the current user' do
      exchange.should_receive( :initial_values= ).with hash_including user_id: current_user.id
      post :create, params
    end

    it 'saves the exchange' do
      exchange.should_receive :save!
      post :create, params
    end
  end
end
