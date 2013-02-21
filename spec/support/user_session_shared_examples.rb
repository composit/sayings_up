shared_examples 'a successful login' do
  it 'sets the user id' do
    user_session.authenticate!
    expect( user_session.user_id ).to eq logged_in_user.id
  end

  it 'returns true to authenticate' do
    expect( user_session.authenticate! ).to be_true
  end

  it 'has an empty hash of errors' do
    user_session.authenticate!
    expect( user_session.errors ).to be_nil
  end
end

