require 'spec_helper'

describe 'manage my account', %q{
  In order to keep track of my identity through conversations
  As a user
  I want to create and manage my account
}, :js do

  context 'create an account' do
    describe 'allows me to create an account' do
      before :each do
        visit '/'
        click_link 'Sign up'
        fill_in 'Username', with: 'Testuser'
        fill_in 'Password', with: 'testpass'
        fill_in 'Password confirmation', with: 'testpass'
        click_button 'Create user'
      end

      it "notifies me of my account creation" do
        page.should have_content 'Thanks for signing up!'
      end

      it "signs me in to my account" do
        page.should have_content 'Log out'
      end
    end
  end
end
