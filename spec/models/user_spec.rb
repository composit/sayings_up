require 'spec_helper'
require 'cancan/matchers'

describe User do
  specify { Factory( :user ).should be_valid }

  describe "abilities" do
    subject { ability }
    let( :ability ) { Ability.new user }

    let( :user ) { Factory :user }
    it { should be_able_to :read, Exchange.new }
    it { should be_able_to :read, Entry.new }
  end

  context "when authenticating against a password" do
    let( :user ) { Factory( :user, :password => "testpass", :password_confirmation => "testpass" ) }

    specify { user.authenticate( "testpass" ).should be_true }
    specify { user.authenticate( "otherpass" ).should be_false }
  end

  context "when validating" do
    it "requires a username" do
      user = Factory.build( :user, :username => nil )
      user.should_not be_valid
      user.errors.messages.should eql( :username => ["can't be blank"] )
    end

    it "requires a unique username" do
      Factory( :user, :username => "testuser" )
      user = Factory.build( :user, :username => "testuser" )
      user.should_not be_valid
      user.errors.messages.should eql( :username => ["is already taken"] )
    end
  end

=begin
  it "has exchanges" do
    user = Factory.build( :user )
    exchange_1 = Factory( :exchange )
    exchange_2 = Factory( :exchange )
    exchange_1.users << user
    exchange_1.save
    exchange_2.users << user
    exchange_2.users << Factory( :user )
    exchange_2.save
    user.exchanges.length.should eql( 2 )
    user.exchanges.should include( exchange_1 )
    user.exchanges.should include( exchange_2 )
  end
=end
end
