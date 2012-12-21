require 'spec_helper'

feature 'logged out user cannot add to an exchange', :js do
  given( :exchange ) { create :exchange_with_entry_and_comment }

  scenario 'user does not see the link to add an entry' do
    visit "/#e/#{exchange.id}"
    expect( page ).to have_no_content RESPOND_TEXT
  end

  scenario 'user does not see the link to add a comment' do
    visit "/#e/#{exchange.id}"
    click_link '1 comment'
    expect( page ).to have_no_content RESPOND_TEXT
  end
end
