require 'spec_helper'

describe UserSessionsController do
  context 'POST' do
    let( :user ) { stub_model User, id: 123 }

    context 'if a user is found by the username' do
      before :each do
        User.stub( :where ).with( username: "testuser" ) { [user] }
      end

      describe 'if the params authenticate' do
        before :each do
          user.stub( :authenticate ).with( "testpass" ) { user }
          post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
        end

        it 'sets the session user' do
          session[:user_id].should == 123
        end

        it 'returns a status of "OK"' do
          response.status.should == 201
        end
      end

      describe 'if the params do not authenticate' do
        before :each do
          user.stub( :authenticate ).with( "testpass" ) { false }
          post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
        end

        it 'does not set the session user' do
          session[:user_id].should be_nil
        end

        it 'returns an unprocessable entity status' do
          response.status.should == 422
        end
      end
    end

    describe 'when no user is found with the given username' do
      before :each do
        User.stub( :where ).with( username: "testuser" ) { [] }
        post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
      end

      it 'does not set the session user' do
        session[:user_id].should be_nil
      end

      it 'returns an unprocessable entity status' do
        response.status.should == 422
      end
    end
  end

  context 'DELETE' do
    before :each do
      session[:user_id] = 123
      delete :destroy, { id: "123", format: :json }
    end
    
    it 'clears the user id from the session' do
      session[:user_id].should be_nil
    end

    it 'responds with a status of "OK"' do
      response.status.should == 204
    end
  end
end
