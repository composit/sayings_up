require 'spec_helper'

describe EntriesController do
  context 'POST' do
    let( :entry ) { mock_model Entry }
    let( :entries ) { stub( new: entry ) }
    let( :exchange ) { mock_model Exchange, entries: entries }
    let( :ability ) { Object.new }

    before :each do
      ability.extend CanCan::Ability
      @controller.stub( :current_ability ) { ability }
      ability.can :read, Exchange
      ability.can :create, Entry
      Exchange.stub( :find ).with( "123" ) { exchange }
    end

    it 'finds the appropriate exchange' do
      Exchange.should_receive( :find ).with "123"
      post :create, { exchange_id: 123, entry: {}, format: :json }
    end
    
    it 'saves the entry'
  end
end
