require 'spec_helper'

feature 'user navigates by tags', :js do
  given( :exchange ) { create :exchange }
  given!( :entry ) { create :entry, exchange: exchange, content: 'first entry' }
  given( :tag ) { create :tag, name: 'firsttag' }
  given!( :tagging ) { create :tagging, tag: tag, exchange: exchange }

  scenario 'user clicks on tag to see exchanges' do
    visit '/'
    click_link 'firsttag'
    expect( page ).to have_content 'first entry'
  end

  scenario 'user clicks on an exchange to see that exchange' do
    visit '/'
    click_link 'firsttag'
    click_link 'check it'
    within( '.content' ) do
      expect( page ).to have_content 'first entry'
    end
  end
end
