require 'spec_helper'

describe ExchangesController do
  context 'GET' do
    it 'tests'
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

    after :each do
      post :create, params
    end

    it 'does not assign the parent comment id if the entry and exchange ids do not match'
    it 'does not save if the user does not own the parent entry'

    it 'assigns the current user' do
      exchange.should_receive( :initial_values= ).with hash_including user_id: current_user.id
    end

    it 'saves the exchange' do
      exchange.should_receive :save
    end
  end
end
