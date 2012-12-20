require 'spec_helper'

describe UserSessionsController do
  render_views

  context 'POST' do
    let( :user_session ) { stub }

    before do
      UserSession.stub( :new ).with( { 'username' => 'testuser', 'password' => 'testpass' } ) { user_session }
    end

    describe 'if the params authenticate' do
      before :each do
        user_session.stub( :authenticate! ) { true }
        user_session.stub( :user_id ) { 123 }
        post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
      end

      it 'sets the session user' do
        expect( session[:user_id] ).to eq 123
      end

      it 'returns a status of "OK"' do
        expect( response.status ).to eq 201
      end

      it 'returns the user id' do
        expect( response.body ).to eq "{\"user_id\":123}"
      end
    end

    describe 'if the params do not authenticate' do
      before :each do
        user_session.stub( :authenticate! ).with { false }
        user_session.stub( :user_id ) { nil }
        user_session.stub( :errors ) { "error message" }
        post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
      end

      it 'does not set the session user' do
        expect( session[:user_id] ).to be_nil
      end

      it 'returns an unprocessable entity status' do
        expect( response.status ).to eq 422
      end

      it 'returns error messages' do
        expect( response.body ).to eq "{\"user_id\":null,\"errors\":\"error message\"}"
      end
    end
  end

  context 'DELETE' do
    before :each do
      session[:user_id] = 123
      delete :destroy, { id: "123", format: :json }
    end
    
    it 'clears the user id from the session' do
      expect( session[:user_id] ).to be_nil
    end

    it 'responds with a status of "OK"' do
      expect( response.status ).to eq 204
    end
  end
end
