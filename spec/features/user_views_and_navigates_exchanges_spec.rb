require 'spec_helper'

feature 'user views an exchange', :js do
  given( :parent_exchange ) { create :exchange_with_entry_and_comment }
  given( :exchange ) { create :exchange, parent_exchange_id: parent_exchange.id, parent_entry_id: parent_exchange.entries.first.id, parent_comment_id: parent_exchange.entries.first.comments.first.id }
  given( :child_exchange ) { create :exchange_with_entry_and_comment, parent_exchange_id: exchange.id, parent_entry_id: exchange.entries.first.id, parent_comment_id: exchange.entries.first.comments.first.id }

  background do
    exchange.entries << build( :entry, content: 'Good stuff' )
    exchange.entries << build( :entry, content: 'Other stuff' )
    exchange.entries.first.comments << build( :comment, content: 'First comment!' )
    parent_exchange.entries.first.content = 'Parent stuff'
    parent_exchange.entries.first.comments.first.content = 'Parent comment'
    parent_exchange.save!
    child_exchange.entries.first.content = 'Child stuff'
    child_exchange.save!
  end

  scenario 'user sees a list of entries in order' do
    visit "/#e/#{exchange.id}"
    pattern = Regexp.new( "Good stuff(.*)Other stuff", Regexp::MULTILINE )
    expect( find( '#exchanges' ).text ).to match pattern
  end

  scenario 'user sees the comments for an entry when they click "comments"' do
    visit "/#e/#{exchange.id}"
    within( '.entry.first-user' ) do
      click_link '1 comment'
    end
    expect( page ).to have_content 'First comment!'
  end

  scenario 'user sees the child exchange when they click through' do
    visit "/#e/#{exchange.id}"
    within( '.entry.first-user' ) do
      click_link '1 comment'
    end
    click_link 'discussion'
    expect( page ).to have_content 'Child stuff'
  end

  scenario 'user sees two exchanges at a time' do
    visit "/#e/#{exchange.id}"
    within( all( '.entry' ).first ) do
      click_link '1 comment'
    end
    click_link 'discussion'
    expect( page ).to have_content 'Child stuff'
    expect( page ).to have_content 'Good stuff'
  end

  scenario 'user does not see the parent exchange once they expand the comments for the child exchange' do
    visit "/#e/#{parent_exchange.id}"
    within( all( '.entry' ).first ) do
      click_link '1 comment'
    end
    click_link 'discussion'
    expect( page ).to have_content 'Parent stuff'
    within( all( '.exchange' ).last ) do
      click_link '1 comment'
    end
    expect( page ).to have_no_content 'Parent stuff'
  end

  scenario 'user sees the parent exchange, entry and comment when they click the back button' do
    visit "/#e/#{exchange.id}"
    click_link 'back'
    expect( page ).to have_content 'Parent stuff'
    expect( page ).to have_content 'Parent comment'
    expect( page ).to have_content 'Good stuff'
  end

  scenario 'user does not see the child exchange once they click back to the parent exchange' do
    visit "/#e/#{child_exchange.id}"
    click_link 'back'
    expect( page ).to have_content 'Good stuff'
    click_link 'back'
    expect( page ).to have_content 'Parent stuff'
    expect( page ).to have_no_content 'Child stuff'
  end

  scenario 'user sees the author of each entry' do
    user1 = create :user, username: 'userone'
    user2 = create :user, username: 'usertwo'
    exchange.entries.first.user = user1
    exchange.entries.last.user = user2
    exchange.save!
    visit "/#e/#{exchange.id}"
    within( all( '.entry' ).first ) do
      expect( page ).to have_content 'userone'
    end
    within( all( '.entry' ).last ) do
      expect( page ).to have_content 'usertwo'
    end
  end

  scenario 'user sees sanitized entry content' do
    exchange.entries << build( :entry, content: "<script>alert('hello!');</script>" )
    visit "/#e/#{exchange.id}"
    expect( page ).to have_content "<script>alert('hello!');</script>"
  end

  scenario 'user sees sanitized comment content' do
    exchange.entries.first.comments << build( :comment, content: "<script>alert('hello!');</script>" )
    visit "/#e/#{exchange.id}"
    click_link '2 comments'
    expect( page ).to have_content "<script>alert('hello!');</script>"
  end

  scenario 'user can click on urls in entry content' do
    exchange.entries << build( :entry, content: 'go here: http://www.google.com/' )
    visit "/#e/#{exchange.id}"
    click_link 'http://www.google.com/'
    expect( current_url ).to eq 'http://www.google.com/'
  end

  scenario 'user can click on urls in comment content' do
    exchange.entries.first.comments << build( :comment, content: 'go here: http://www.google.com/' )
    visit "/#e/#{exchange.id}"
    click_link '2 comment'
    click_link 'http://www.google.com/'
    expect( current_url ).to eq 'http://www.google.com/'
  end
end
