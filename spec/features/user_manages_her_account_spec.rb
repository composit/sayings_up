require 'spec_helper'

feature 'user manages her account', :js do
  scenario 'user creates an account' do
    visit '/'
    fill_in 'Username', with: 'Testuser'
    fill_in 'password', with: 'testpass'
    click_button 'Sign up or sign in'
    expect( page ).to have_content 'Welcome, Testuser'
  end

  scenario 'user attempts to sign up with invalid data' do
    visit '/'
    click_button 'Sign up or sign in'
    expect( page ).to have_content 'be blank'
  end

  scenario 'user logs in' do
    sign_in
    expect( page ).to have_content 'Welcome, testuser'
  end

  scenario 'user logs out' do
    sign_in
    expect( page ).to have_content 'Welcome, testuser'
    click_link 'Sign out'
    expect( page ).to have_content 'You are signed out'
  end

  scenario 'user is still logged in after a refresh' do
    sign_in
    expect( page ).to have_content 'Welcome, testuser'
    visit '/'
    expect( page ).to have_content 'Welcome, testuser'
  end
end

def sign_in
  create( :user, username: 'testuser', password: 'testpass', password_confirmation: 'testpass' )
  visit '/'
  fill_in 'Username', with: 'testuser'
  fill_in 'Password', with: 'testpass'
  click_button 'Sign up or sign in'
end
