require 'spec_helper'

feature 'logged in user can add to an exchange' do
  scenario 'user can add a comment to any entry'
  scenario 'user can add an entry to an exchange he is involved in'
  scenario 'entries added by a logged in user are attributed to that user'
  scenario 'user cannot add an entry to an exchange she is not involved in'
  scenario 'comments added by a logged in user are attributed to that user'
end
