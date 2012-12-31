require 'spec_helper'

feature 'logged in user can add to an exchange', :js do
  given( :exchange ) { create :exchange }
  given( :user ) { create :user, username: 'testuser' }

  background do
    exchange.entries << build( :entry, user: user, content: 'Go tell it on the mountain', exchange: exchange )
    exchange.save!
    sign_in_as user
  end

  scenario 'user can add a comment to any entry' do
    visit "/#e/#{exchange.id}"
    click_link '0 comments'
    click_link 'add comment'
    within( '#new-comment-form' ) do
      fill_in 'content', with: 'new comment'
      click_button 'Add comment'
    end
    expect( page ).to have_content '1 comment'
    pattern = Regexp.new( "new comment(.*)testuser", Regexp::MULTILINE )
    expect( find( '.comments' ).text ).to match pattern
  end

  scenario 'user can add an entry to an exchange he is involved in' do
  end
  scenario 'entries added by a logged in user are attributed to that user'
  scenario 'user cannot add an entry to an exchange she is not involved in'
  scenario 'user can respond to comments on one of her entries'
  scenario 'user cannat respond to comments on another user\'s entries'
end
