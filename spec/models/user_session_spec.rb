require 'spec_helper'

describe UserSession do
  let( :user_session ) { UserSession.new username: 'testuser', password: 'testpass' }
  let( :user ) { mock_model User, id: 234, username: 'testuser' }

  it 'allows a user to be set' do
    new_session = UserSession.new user: user
    expect( new_session.user_id ).to eq 234
  end

  it 'returns the username' do
    new_session = UserSession.new user: user
    expect( new_session.username ).to eq 'testuser'
  end

  context 'with a user' do
    before do
      User.stub( :where ).with( username: 'testuser' ) { [user] }
    end

    context 'with a valid password' do
      before do
        user.stub( :authenticate ).with( 'testpass' ) { user }
      end

      it_behaves_like 'a successful login' do
        let(:logged_in_user) { user }
      end
    end

    context 'with an invalid password' do
      before do
        user.stub( :authenticate ).with( 'testpass' ) { false }
      end

      it 'does not set the user id' do
        user_session.authenticate!
        expect( user_session.user_id ).to be_nil
      end

      it 'returns false to authenicate' do
        expect( user_session.authenticate! ).to be_false
      end

      it 'has an error' do
        user_session.authenticate!
        expect( user_session.errors ).to eq( { 'username' => ['exists and password does not match'] } )
      end
    end
  end

  context 'without a user' do
    let(:new_user) { mock_model User, id: 345, username: 'testuser' }

    before do
      User.stub(:where).with(username: 'testuser') { [] }
      User.stub(:create) { new_user }
    end

    context 'with valid user data' do
      before do
        new_user.stub(:save) { true }
      end

      it 'creates a user' do
        User.should_receive(:create).with(username: 'testuser', password: 'testpass')
        user_session.authenticate!
      end
      
      it_behaves_like 'a successful login' do
        let(:logged_in_user) { new_user }
      end
    end

    context 'with invalid user data' do
      it 'returns an error' do
        new_user.stub(:save) { false }
        user_session.authenticate!
        expect( user_session.errors ).to eq( { 'username or password' => ['can\'t be blank'] } )
      end
    end
  end
end
