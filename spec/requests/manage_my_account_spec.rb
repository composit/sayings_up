require 'spec_helper'

describe 'manage my account', %q{
  In order to keep track of my identity through conversations
  As a user
  I want to create and manage my account
}, :js do

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
    Factory( :user, username: 'testuser', password: 'testpass', password_confirmation: 'testpass' )
    visit '/'
    click_link 'Sign in'
    fill_in 'Username', with: 'testuser'
    fill_in 'Password', with: 'testpass'
    click_button 'Sign in'
    page.should have_content 'Welcome back, testuser'
  end

  it 'logs out' do
    Factory( :user, username: 'testuser', password: 'testpass', password_confirmation: 'testpass' )
    visit '/'
    click_link 'Sign in'
    fill_in 'Username', with: 'testuser'
    fill_in 'Password', with: 'testpass'
    click_button 'Sign in'
    page.should have_content 'Welcome back, testuser'
    click_link 'Sign out'
    page.should have_content 'You are signed out'
  end
end
