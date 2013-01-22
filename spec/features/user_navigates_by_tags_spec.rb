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
end
