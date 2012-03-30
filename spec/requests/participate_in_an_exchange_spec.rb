require 'spec_helper'

describe "user participates in an exchange", %q{
  In order to have a meaningful discussion
  As a user
  I want to be able to add entries to an exchange
}, :js do

  let( :exchange ) { Factory( :exchange ) }
  let( :user ) { Factory( :user, username: 'testuser', password: 'testpass', password_confirmation: 'testpass' ) }
  let( :respond_text ) { 'respond' }

  before :each do
    exchange.entries << Factory.build( :entry, :content => "Good stuff", :user => user )
    exchange.entries << Factory.build( :entry, :content => "Other stuff" )
  end

  context "not logged in" do
    it "does not display the 'respond' dialog" do
      visit "/#e/#{exchange.id}"
      page.should have_no_content respond_text
    end
  end

  context 'logged in' do
    before :each do
      @other_exchange = Factory( :exchange )
      visit '/'
      click_link 'Sign in'
      fill_in 'Username', with: 'testuser'
      fill_in 'Password', with: 'testpass'
      click_button 'Sign in'
    end

    context "viewing an exchange I am not a part of" do
      it "does not display the 'respond' dialog" do
        #TODO visiting the exchange page directly freezes capybara-webkit
        click_link @other_exchange.id.to_s
        #visit "/#e/#{@other_exchange.id}"
        page.should have_no_content respond_text
      end
    end

    context "viewing an exchange I am involved in" do
      before :each do
        #TODO visiting the exchange page directly freezes capybara-webkit
        click_link exchange.id.to_s
        #visit "/#e/#{exchange.id}"
      end

      it "displays the 'respond' dialog" do
        page.should have_content respond_text
      end

      it "displays my response when I submit one"
      it "does not allow me to submit a blank response"
      it "allows me to delete my previous entries, replacing the content with 'deleted'"
      it "does not allow me to delete entries not by me"
    end

    context "responding to a comment on one of my entries" do
      it "creates a new exchange when I respond to a comment"
    end
  end
end
