describe ApplicationController do
  it 'sets the current user via the session' do
    user = stub
    User.stub( :find ).with( 123 ) { user }
    session[:user_id] = 123
    subject.send( :current_user ).should == user
  end
end
