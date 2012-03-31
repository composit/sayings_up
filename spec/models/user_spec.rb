require 'spec_helper'
require 'cancan/matchers'

describe User do
  specify { FactoryGirl.build( :user ).should be_valid }

  it "only includes the id and username attributes in the json" do
    user = FactoryGirl.build :user
    user.to_json.should =~ /^{\"_id\":\"\w+\",\"username\":\"\w+\"}$/
  end

  describe "abilities" do
    subject { ability }
    let( :ability ) { Ability.new user }

    let( :user ) { FactoryGirl.create :user }
    it { should be_able_to :read, Exchange.new }
    it { should be_able_to :read, Entry.new }
    it { should be_able_to :create, User.new }
  end

  context "when validating" do
    it "requires a username" do
      user = FactoryGirl.build( :user, username: nil )
      user.should_not be_valid
      user.errors.messages.should == { username: ["can't be blank"] }
    end

    it "requires a unique username" do
      FactoryGirl.create( :user, username: "testuser" )
      user = FactoryGirl.build( :user, username: "testuser" )
      user.should_not be_valid
      user.errors.messages.should == { username: ["is already taken"] }
    end

    it "requires a password" do
      user = FactoryGirl.build( :user, password: "", password_confirmation: "" )
      user.should_not be_valid
      user.errors.messages.should == { password_digest: ["can't be blank"] }
    end
  end

  context 'authenticating' do
    let( :user ) { FactoryGirl.build :user, password: 'testpass' }

    specify { user.authenticate( 'testpass' ).should == user }
    specify { user.authenticate( 'otherpass' ).should be_false }
  end
end
