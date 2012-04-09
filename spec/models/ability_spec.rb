require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let( :user ) { FactoryGirl.create :user }
  let( :ability ) { Ability.new user }

  it { should be_able_to :read, Exchange.new }
  it { should be_able_to :read, Entry.new }
  it { should be_able_to :create, User.new }

  context 'exchanges' do
    let( :exchange ) { FactoryGirl.build :exchange }

    before :each do
      exchange.entries << FactoryGirl.create( :entry, user: user )
    end

    it { should be_able_to :create, exchange }

    it 'is not able to create an exchange if it is not a user in the exchange' do
      exchange.entries.first.user = FactoryGirl.create :user
      ability.should_not be_able_to :create, exchange
    end

    it 'is not able to create an exchange if it is the secondary user in the exchange' do
      exchange.entries.first.user = FactoryGirl.create :user
      exchange.entries << FactoryGirl.build( :entry, user: user )
      ability.should_not be_able_to :create, exchange
    end

    it 'is not able to create an exchange if it is not the user for the parent entry'

    it 'is able to update the exchange if it is a user in the exchange' do
      exchange.save!
      ability.should be_able_to :update, exchange
    end

    it 'is not able to update an exchange if it is not a user in the exchange' do
      exchange.entries.first.user = FactoryGirl.create :user
      ability.should_not be_able_to :update, exchange
    end
  end

  context 'entries' do
    let( :exchange ) { FactoryGirl.create :exchange }
    let( :new_entry ) { exchange.entries.build }

    before :each do
      new_entry.user_id = user.id
      exchange.entries << FactoryGirl.build( :entry, user: user )
    end

    it 'is able to create an entry if it is a user on the entry\'s exchange' do
      ability.should be_able_to :create, new_entry
    end

    it 'is not able to create an entry if it is not a user on the entry\'s exchange' do
      exchange.entries.first.user = FactoryGirl.create :user
      puts "entries: #{exchange.entries.inspect}"
      ability.should_not be_able_to :create, new_entry
    end
  end
end
