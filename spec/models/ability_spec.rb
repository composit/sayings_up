require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let( :user ) { FactoryGirl.create :user }
  let( :ability ) { Ability.new user }

  it { should be_able_to :read, Exchange.new }
  it { should be_able_to :read, Entry.new }
  it { should be_able_to :create, User.new }
  context 'creating' do
    before :each do
      parent_exchange = FactoryGirl.create( :exchange )
      exchange = FactoryGirl.build( :exchange, parent_exchange: parent_exchange )
      exchange.entries << FactoryGirl.build( :entry, user: user )
    end

    it { should be_able_to :create, exchange }
    it 'should not be able to create an exchange if it is not the primary user in the exchange'
    it 'should not be able to create an exchange if it is not a user in the parent exchange'
  end
end
