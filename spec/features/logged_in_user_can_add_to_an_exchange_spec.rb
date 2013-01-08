require 'spec_helper'

feature 'logged in user can add to an exchange', :js do
  given( :exchange ) { create :exchange }
  given( :user ) { create :user, username: 'testuser' }
  given( :entry ) { build :entry, user: user, content: 'Go tell it on the mountain' }

  background do
    exchange.entries << entry
    exchange.save!
  end

  scenario 'user can add a comment to any entry' do
    sign_in_as user
    visit "/#e/#{exchange.id}"
    sleep 0.1 #TODO find the race condition
    click_link '0 comments'
    click_link 'add comment'
    within( '#new-comment-form' ) do
      fill_in 'content', with: 'new comment'
      click_button 'Add comment'
    end
    expect( page ).to have_content '1 comment'
    expect( find( '.comments' ).text ).to match /new comment(.*)testuser/m
  end

  scenario 'user can add an entry to an exchange he is involved in' do
    sign_in_as user
    visit "/#e/#{exchange.id}"
    click_link 'respond'
    within '#new-entry-form' do
      fill_in 'content', with: 'test response'
      click_button 'Respond'
    end
    expect( page ).to have_content 'test response'
  end

  scenario 'entries added by a logged in user are attributed to that user' do
    sign_in_as user
    visit "/#e/#{exchange.id}"
    click_link 'respond'
    within '#new-entry-form' do
      fill_in 'content', with: 'test response'
      click_button 'Respond'
    end
    expect( page ).to have_content /test response(.*)testuser/m
  end

  scenario 'user cannot add an entry to an exchange she is not involved in' do
    sign_in_as create :user
    visit "/#e/#{exchange.id}"
    expect( page ).to have_no_content 'respond'
  end

  scenario 'user can respond to comments on one of her entries' do
    sign_in_as user
    entry.comments << build( :comment )
    exchange.save!
    visit "/"
    visit "/#e/#{exchange.id}"
    click_link '1 comment'
    within '.comments' do
      click_link 'respond'
      fill_in 'content', with: 'test response'
      click_button 'Respond'
      click_link 'discussion(2)'
    end
    expect( page ).to have_content 'test response'
  end

  scenario 'user cannot respond to comments on another user\'s entries' do
    other_user = create :user
    other_entry = build :entry, user: other_user
    other_entry.comments << build( :comment )
    exchange.entries << other_entry
    exchange.save!
    sign_in_as user
    visit "/#e/#{exchange.id}"
    click_link '1 comment'
    within( '.comments' ) do
      expect( page ).to have_no_content 'respond'
    end
  end

  scenario 'user sees respond links immediately upon login' do
    visit "/#e/#{exchange.id}"
    click_link 'Sign in'
    fill_in 'Username', with: user.username
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect( page ).to have_content 'respond'
  end

  scenario 'user loses respond links immediately on logout' do
    sign_in_as user
    visit "/#e/#{exchange.id}"
    click_link 'Sign out'
    expect( page ).to have_no_content 'respond'
  end
end
