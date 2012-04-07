require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let( :user ) { FactoryGirl.create :user }
  let( :ability ) { Ability.new user }

  it { should be_able_to :read, Exchange.new }
  it { should be_able_to :read, Entry.new }
  it { should be_able_to :create, User.new }

  context 'creating exchanges' do
    before :each do
      #parent_exchange = FactoryGirl.create :exchange
      @exchange = FactoryGirl.build :exchange #, parent_exchange: parent_exchange
      @exchange.entries << FactoryGirl.build( :entry, user: user )
    end

    it { should be_able_to :create, @exchange }

    it 'is not able to create an exchange if it is not a user in the exchange' do
      @exchange.entries.first.user = FactoryGirl.create :user
      ability.should_not be_able_to :create, @exchange
    end

    it 'is not able to create an exchange if it is the secondary user in the exchange' do
      @exchange.entries.first.user = FactoryGirl.create :user
      @exchange.entries << FactoryGirl.build( :entry, user: user )
      ability.should_not be_able_to :create, @exchange
    end

    it 'is not able to create an exchange if it is not the user for the parent entry'
  end

  context 'creating entries' do
    let( :exchange ) { FactoryGirl.create :exchange }

    before :each do
      exchange.entries << FactoryGirl.build( :entry, user: user )
    end

    it 'is able to create an entry if it is a user on the entry\'s exchange' do
      ability.should be_able_to :create, exchange.entries.build
    end

    it 'is not able to create an entry if it is not a user on the entry\'s exchange' do
      exchange.entries.first.user = FactoryGirl.create :user
      ability.should_not be_able_to :create, exchange.entries.build
    end
  end
end
