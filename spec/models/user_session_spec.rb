describe UserSession do
  let( :user_session ) { UserSession.new username: 'testuser', password: 'testpass' }
  let( :user ) { mock_model User, id: 234 }

  context 'with a user' do
    before do
      User.stub( :where ).with( username: 'testuser' ) { [user] }
    end

    context 'with a valid password' do
      before do
        user.stub( :authenticate ).with( 'testpass' ) { user }
      end

      it 'sets the user id' do
        user_session.authenticate!
        expect( user_session.user_id ).to eq 234
      end

      it 'returns true to authenticate' do
        expect( user_session.authenticate! ).to be_true
      end

      it 'has an empty hash of errors' do
        expect( user_session.errors ).to be_empty
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
        expect( user_session.errors ).to eq( { 'username or password' => ['is incorrect'] } )
      end
    end
  end

  context 'without a user' do
    before do
      User.stub( :where ).with( username: 'testuser' ) { [] }
    end

    it 'does not set the user id' do
      user_session.authenticate!
      expect( user_session.user_id ).to be_nil
    end

    it 'returns false to authenticate' do
      expect( user_session.authenticate! ).to be_false
    end

    it 'has an error' do
      expect( user_session.errors ).to eq( { 'username or password' => ['is incorrect'] } )
    end
  end
end
