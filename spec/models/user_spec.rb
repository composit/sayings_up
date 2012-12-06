require 'spec_helper'

describe User do
  specify { expect( build :user ).to be_valid }

  it "only includes the id and username attributes in the json" do
    user = build :user
    expect( user.to_json ).to match /^{\"_id\":\"\w+\",\"username\":\"\w+\"}$/
  end

  context "when validating" do
    it "requires a username" do
      user = build( :user, username: nil )
      expect( user ).not_to be_valid
      expect( user.errors.messages ).to eq( { username: ["can't be blank"] } )
    end

    it "requires a unique username" do
      create( :user, username: "testuser" )
      user = build( :user, username: "testuser" )
      expect( user ).not_to be_valid
      expect( user.errors.messages ).to eq( { username: ["is already taken"] } )
    end

    it "requires a password" do
      user = build( :user, password: "", password_confirmation: "" )
      expect( user ).not_to be_valid
      expect( user.errors.messages ).to eq( { password_digest: ["can't be blank"] } )
    end
  end

  context 'authenticating' do
    let( :user ) { build :user, password: 'testpass' }

    specify { expect( user.authenticate 'testpass' ).to eq user }
    specify { expect( user.authenticate 'otherpass' ).to be_false }
  end
end
