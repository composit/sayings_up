require 'spec_helper'

describe 'user manages her account' do
  before :each do
    exchange = create :exchange
  end

  it 'creates an account' do
    visit '/'
    click_link 'Sign up'
    fill_in 'Username', with: 'Testuser'
    fill_in 'Password', with: 'testpass'
    fill_in 'Password confirmation', with: 'testpass'
    click_button 'Create user'
    page.should have_content 'Welcome, Testuser'
  end

  it 'logs in' do
    sign_in
    page.should have_content 'Welcome, testuser'
  end

  it 'logs out' do
    sign_in
    page.should have_content 'Welcome, testuser'
    click_link 'Sign out'
    page.should have_content 'You are signed out'
  end

  it 'remembers that a user is logged in after a refresh' do
    sign_in
    page.should have_content 'Welcome, testuser'
    visit '/'
    page.should have_content 'Welcome, testuser'
  end
end

def sign_in
  create( :user, username: 'testuser', password: 'testpass', password_confirmation: 'testpass' )
  visit '/'
  click_link 'Sign in'
  fill_in 'Username', with: 'testuser'
  fill_in 'Password', with: 'testpass'
  click_button 'Sign in'
end
