require 'spec_helper'

describe ApplicationController do
  let( :user ) { stub id: 123 }

  before :each do
    User.stub( :find ).with( 123 ) { user }
    session[:user_id] = 123
  end

  it 'sets the current user session via the session' do
    expect( subject.send( :current_user_session ).user_id ).to eq user.id
  end

  it 'stores the current user rather than continuing to find via the database' do
    bad_user = stub id: 234
    User.stub( :find ).with( 234 ) { bad_user }
    session[:user_id] = 123
    expect( subject.send( :current_user_session ).user_id ).to eq user.id
    session[:user_id] = 234
    expect( subject.send( :current_user_session ).user_id ).to eq user.id
  end

  it 'returns nil if there is no user id' do
    session[:user_id] = nil
    expect( subject.send :current_user_session ).to be_nil
  end
end
