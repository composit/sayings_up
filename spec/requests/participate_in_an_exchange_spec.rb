require 'spec_helper'

describe 'user participates in an exchange', %q{
  In order to have a meaningful discussion
  As a user
  I want to be able to add entries to an exchange
}, :js, :slow do

  let( :exchange ) { FactoryGirl.create( :exchange ) }
  let( :user ) { FactoryGirl.create( :user, username: 'testuser', password: 'testpass', password_confirmation: 'testpass' ) }
  let( :respond_text ) { 'respond' }

  before :each do
    exchange.entries << FactoryGirl.build( :entry, :content => 'Good stuff', :user => user )
    exchange.entries << FactoryGirl.build( :entry, :content => 'Other stuff' )
  end

  context 'not logged in' do
    it 'does not display the "respond" dialog' do
      visit "/#e/#{exchange.id}"
      page.should have_no_content respond_text
    end
  end

  context 'logged in' do
    before :each do
      @other_exchange = FactoryGirl.create( :exchange )
      sign_in
    end

    context 'viewing an exchange I am not a part of' do
      it 'does not display the "respond" dialog' do
        #TODO visiting the exchange page directly freezes capybara-webkit
        #click_link @other_exchange.id.to_s
        visit "/#e/#{@other_exchange.id}"
        page.should have_no_content respond_text
      end
    end

    context 'viewing an exchange I am involved in' do
      before :each do
        #TODO visiting the exchange page directly freezes capybara-webkit
        click_link exchange.id.to_s
        #visit "/#e/#{exchange.id}"
      end

      it 'displays the "respond" dialog' do
        page.should have_content respond_text
      end

      it 'displays my response when I submit one' do
        click_link respond_text
        fill_in 'Response', with: 'test response'
        click_button 'Respond'
        page.should have_content 'test response'
      end
      
      it 'does not allow me to submit a blank response'
      it 'allows me to delete my previous entries, replacing the content with "deleted"'
      it 'does not allow me to delete entries not by me'
    end

    context 'commenting on an exchange' do
      it 'allows me to comment on an exchange' do
        sign_in
        click_link exchange.id.to_s
        click_link 'comments'
        click_link 'add comment'
        fill_in 'Comment', with: 'test comment'
        click_button 'Add comment'
        page.should have_content 'test comment'
      end

      it 'does not display the comment link if I am not signed in' do
        visit '/'
        click_link exchange.id.to_s
        click_link 'comments'
        page.should have_no_content 'Add comment'
      end
    end

    context 'responding to a comment on one of my entries' do
      it 'creates a new exchange', :focus do
        exchange.entries.first.comments << FactoryGirl.create( :comment, content: 'Good comment' )
        sign_in
        click_link exchange.id.to_s
        click_link 'comments'
        within( '.comment' ) do
          click_link 'respond'
          fill_in 'content', with: 'test response'
          click_button 'Respond'
        end
        page.should have_content '2 entries'
      end
    end
  end

  def sign_in
    visit '/'
    sign_out
    click_link 'Sign in'
    fill_in 'Username', with: 'testuser'
    fill_in 'Password', with: 'testpass'
    click_button 'Sign in'
  end

  def sign_out
    if page.has_content? 'Sign out'
      click_link 'Sign out'
    end
  end
end
