require 'spec_helper'

describe User do
  specify { build( :user ).should be_valid }

  it "only includes the id and username attributes in the json" do
    user = build :user
    user.to_json.should =~ /^{\"_id\":\"\w+\",\"username\":\"\w+\"}$/
  end

  context "when validating" do
    it "requires a username" do
      user = build( :user, username: nil )
      user.should_not be_valid
      user.errors.messages.should == { username: ["can't be blank"] }
    end

    it "requires a unique username" do
      create( :user, username: "testuser" )
      user = build( :user, username: "testuser" )
      user.should_not be_valid
      user.errors.messages.should == { username: ["is already taken"] }
    end

    it "requires a password" do
      user = build( :user, password: "", password_confirmation: "" )
      user.should_not be_valid
      user.errors.messages.should == { password_digest: ["can't be blank"] }
    end
  end

  context 'authenticating' do
    let( :user ) { build :user, password: 'testpass' }

    specify { user.authenticate( 'testpass' ).should == user }
    specify { user.authenticate( 'otherpass' ).should be_false }
  end
end
