require 'spec_helper'

feature 'user views an exchange', :js do
  given( :exchange ) { create :exchange }
    
  background do
    exchange.entries << build( :entry, :content => "Good stuff" )
    exchange.entries << build( :entry, :content => "Other stuff" )
    visit "/#e/#{exchange.id}"
  end
      
  scenario 'user sees a list of entries in order' do
    visit "/#e/#{exchange.id}"
    pattern = Regexp.new( "Good stuff(.*)Other stuff", Regexp::MULTILINE )
    expect( find( '#exchanges' ).text ).to match pattern
  end

  scenario 'user sees the comments for an entry when they click "comments"'
  scenario 'user sees the child exchange when they click through'
  scenario 'user sees two exchanges at a time'
  scenario 'user does not see the parent exchange once they expand the comments for the child exchange'
  scenario 'user sees the parent exchange, entry and comment when they click the back button'
  scenario 'user does not see the child exchange once they click back to the parent exchange'
  scenario 'user sees the author of each entry'
  scenario 'user sees sanitized entry content'
  scenario 'user sees sanitized comment content'
  scenario 'user can click on urls in entry content'
  scenario 'user can click on urls in comment content'
end
