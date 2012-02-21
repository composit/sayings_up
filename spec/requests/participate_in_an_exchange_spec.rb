require 'spec_helper'

describe "user participates in an exchange", %q{
  In order to have a meaningful discussion
  As a user
  I want to be able to add entries to an exchange
}, :js do

  let( :exchange ) { Factory( :exchange ) }
  let( :user ) { Factory( :user ) }
  let( :respond_text ) { 'respond' }

  before :each do
    exchange.entries << Factory( :entry, :content => "Good stuff", :user => user )
    exchange.entries << Factory( :entry, :content => "Other stuff" )
  end

  context "not logged in" do
    it "does not display the 'respond' dialog" do
      visit "/##{exchange.id}"
      page.should have_no_content respond_text
    end
  end

  context 'logged in' do
    before :each do
      pending
    end

    context "viewing an exchange I am not a part of" do
      it "does not display the 'respond' dialog" do
        visit "/##{exchange.id}"
        page.should have_no_content respond_text
      end
    end

    context "viewing an exchange I am involved in" do
      it "displays the 'respond' dialog"
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
