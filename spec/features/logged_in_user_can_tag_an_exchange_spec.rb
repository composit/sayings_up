require 'spec_helper'

feature 'logged in user can tag an exchange', :js do
  given( :exchange ) { create :exchange }
  given( :user ) { create :user, username: 'testuser' }

  background do
    sign_in_as user
  end

  scenario 'user can add a tag to an exchange' do
    visit "/#e/#{exchange.id}"
    click_link 'new tag'
    fill_in "tag_name", with: "newtag"
    click_button "Add tag"
    within '.taggings' do
      expect( page ).to have_content 'newtag'
    end
  end

  xscenario 'user can add to an existing tag' do
    tagging = create :tagging, exchange: exchange
    visit "/#e/#{exchange.id}"
    within '.taggings' do
      click_link '+'
      expect( page ).to have_content '-'
      expect( page ).to have_no_content '+'
    end
  end

  scenario 'user can subtract from an existing tag'
  scenario 'user can remove a tag if they are the only tagger'
end
