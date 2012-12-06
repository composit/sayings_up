describe ApplicationController do
  let( :user ) { stub }

  before :each do
    User.stub( :find ).with( 123 ) { user }
    session[:user_id] = 123
  end

  it 'sets the current user via the session' do
    expect( subject.send :current_user ).to eq user
  end

  it 'stores stores the current user rather than continuing to find via the database', :focus do
    bad_user = stub
    User.stub( :find ).with( 234 ) { bad_user }
    session[:user_id] = 123
    expect( subject.send :current_user ).to eq user
    session[:user_id] = 234
    expect( subject.send :current_user ).to eq user
  end

  it 'returns nil if there is no user id' do
    session[:user_id] = nil
    expect( subject.send :current_user ).to be_nil
  end
end
