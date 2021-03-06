require 'spec_helper'

feature 'logged in user can tag an exchange', :js do
  given( :exchange ) { create :exchange }
  given( :user ) { create :user, username: 'testuser' }
  given( :tag ) { create :tag, name: 'testtag' }
  given!( :tagging ) { create :tagging, exchange: exchange, tag: tag }

  background do
    sign_in_as user
  end

  scenario 'user can add a tag to an exchange' do
    visit "/#e/#{exchange.id}"
    click_link 'new tag'
    fill_in "tag_name", with: "newtag"
    click_button "Add tag"
    within '.exchange-tags' do
      expect( page ).to have_content 'newtag'
      expect( page ).to have_content '-'
    end
  end

  scenario 'user can add to an existing tag' do
    visit "/#e/#{exchange.id}"
    within '.exchange-tags .actions' do
      click_link '+'
      expect( page ).to have_content '-'
      expect( page ).to have_no_content '+'
    end
  end

  scenario 'user can subtract from an existing tag' do
    visit "/#e/#{exchange.id}"
    within '.exchange-tags .actions' do
      click_link '+'
      visit "/#e/#{exchange.id}"
      click_link '-'
      expect( page ).to have_content '+'
      expect( page ).to have_no_content '-'
    end
  end

  scenario 'user can remove a tag if they are the only tagger' do
    tagging.update_attributes user: user
    visit "/#e/#{exchange.id}"
    within '.exchange-tags .actions' do
      click_link '+'
      click_link '-'
      expect( page ).to have_no_content 'testtag'
    end
  end
end
