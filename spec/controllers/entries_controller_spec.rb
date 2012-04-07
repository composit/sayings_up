require 'spec_helper'

describe EntriesController do
  context 'POST' do
    let( :current_user ) { stub }
    let( :entry ) { mock_model( Entry ).as_null_object }
    let( :entries ) { stub( new: entry ) }
    let( :exchange ) { mock_model Exchange, entries: entries }
    let( :ability ) { Object.new }
    let( :params ) { { exchange_id: 123, entry: {}, format: :json } }

    before :each do
      @controller.stub( :current_user ) { current_user }
      ability.extend CanCan::Ability
      @controller.stub( :current_ability ) { ability }
      ability.can :read, Exchange
      ability.can :create, Entry
      Exchange.stub( :find ).with( "123" ) { exchange }
    end

    after :each do
      post :create, params
    end

    it 'finds the appropriate exchange' do
      Exchange.should_receive( :find ).with "123"
    end

    it 'assigns the current user' do
      entry.should_receive( :user= ).with( current_user )
    end

    it 'saves the entry' do
      entry.should_receive :save
    end
  end
end
