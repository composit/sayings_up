require 'spec_helper'

feature 'tag an exchange' do
  scenario 'user can add a tag to an exchange' do
    exchange = create :exchange
    user = create :user
    visit "/#e/#{exchange.id}"
    fill_in "tag_name", with: "newtag"
    click_button "add tag"
    within '#tags' do
      expect( page ).to have_content 'newtag'
    end
  end

  scenario 'user can add to an existing tag'
  scenario 'user can remove a tag'
end
