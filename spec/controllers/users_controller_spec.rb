require 'spec_helper'

describe UsersController do
  context 'POST' do
    let( :params ) { { user: { username: "testuser" } } }
    let( :new_user ) { mock_model( User, id: 123 ).as_null_object }

    before :each do
      User.stub( :new ).and_return( new_user )
    end
    
    it "builds a new user with the passed user parameters" do
      User.should_receive( :new ).with( { "username" => "testuser" } ) { new_user }
      post :create, params
    end

    it "attempts to save the new user record" do
      new_user.should_receive( :save )
      post :create, params
    end

    describe "when the save is successful" do
      it "signs the user in to their new account" do
        post :create, params
        session[:user_id].should == new_user.id
      end
    end

    describe "when the save fails" do
      before :each do
        new_user.stub( :save ) { false }
        post :create, params
      end

      it "returns an unprocessable entity status" do
        response.status.should == 406
      end
    end
  end
end
