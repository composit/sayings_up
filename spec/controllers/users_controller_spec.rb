require 'spec_helper'

describe UsersController do
  context 'POST' do
    let( :params ) { { user: { username: "testuser" }, format: :json } }
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
      before :each do
        new_user.stub( :save ) { true }
        post :create, params
      end

      it "signs the user in to their new account" do
        expect( session[:user_id] ).to eq new_user.id
      end

      it "returns a status of 'OK'" do
        expect( response.status ).to eq 201
      end
    end

    describe "when the save fails" do
      before :each do
        new_user.stub( :save ) { false }
        post :create, params
      end

      it "does not log the user in" do
        expect( session[:user_id] ).to be_nil
      end

      it "returns an unprocessable entity status" do
        expect( response.status ).to eq 422
      end
    end
  end
  
  context 'GET/1' do
    it 'assigns the user' do
      user = double
      ability = Object.new.extend CanCan::Ability
      ability.can :read, user
      @controller.stub( :current_ability ) { ability }
      User.stub( :find ).with( '123' ) { user }
      get :show, id: 123
      expect( assigns[:user] ).to eq user
    end
  end
end
