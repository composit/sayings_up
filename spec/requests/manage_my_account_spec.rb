require 'spec_helper'

describe 'manage my account', %q{
  In order to keep track of my identity through conversations
  As a user
  I want to create and manage my account
}, :js do

  context 'create an account' do
    it 'allows me to create an account' do
      visit '/'
      click_link 'Sign up'
      fill_in 'Username', with: 'Testuser'
      fill_in 'Password', with: 'testpass'
      fill_in 'Password confirmation', with: 'testpass'
      click_link 'Sign up'
      page.should have_content 'Thanks for signing up!'
      page.should have_content 'Log out'
    end
  end
end
