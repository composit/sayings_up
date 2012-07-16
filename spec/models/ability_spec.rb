require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let( :user ) { create :user }
  let( :ability ) { Ability.new user }

  it { should be_able_to :read, Exchange.new }
  it { should be_able_to :read, Entry.new }
  it { should be_able_to :create, User.new }

  context 'exchanges' do
    let( :parent_entry ) { create :entry, user: user }
    let( :parent_exchange ) { build :exchange, entries: [parent_entry] }
    let( :initial_entry ) { create :entry }
    let( :response_entry ) { create :entry, user: user }
    let( :exchange ) { build :exchange, parent_exchange: parent_exchange, parent_entry: parent_entry, entries: [initial_entry, response_entry] }

    it { should be_able_to :create, exchange }

    it 'is not able to create an exchange if it is not a user in the exchange' do
      response_entry.user = create :user
      ability.should_not be_able_to :create, exchange
    end

    it 'is not able to create an exchange if it is not the user for the parent entry' do
      parent_entry.user = create :user
      ability.should_not be_able_to :create, exchange
    end

    it 'is able to update the exchange if it is a user in the exchange' do
      exchange.save!
      ability.should be_able_to :update, exchange
    end

    it 'is not able to update an exchange if it is not a user in the exchange' do
      response_entry.user = create :user
      ability.should_not be_able_to :update, exchange
    end
  end

  context 'entries' do
    let( :exchange ) { create :exchange }
    let( :new_entry ) { exchange.entries.build }

    before :each do
      exchange.entries << build( :entry, user: user )
    end

    it 'is able to create an entry if it is a user on the entry\'s exchange' do
      ability.should be_able_to :create, new_entry
    end

    it 'is not able to create an entry if it is not a user on the entry\'s exchange' do
      exchange.entries.first.user = create :user
      ability.should_not be_able_to :create, new_entry
    end
  end

  context 'comments' do
    it { should be_able_to :create, Comment.new }
    #TODO what if the user is not logged in?
  end
end
