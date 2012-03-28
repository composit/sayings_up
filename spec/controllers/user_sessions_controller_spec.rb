require 'spec_helper'

describe UserSessionsController do
  context 'POST' do
    let( :user ) { stub_model User, id: 123 }

    before :each do
      User.stub( :find_by_username ).with( "testuser" ) { user }
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
end
