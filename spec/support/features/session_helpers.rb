module Features
  module SessionHelpers
    def sign_in_as( user )
      visit '/'
      click_link 'Sign in'
      fill_in 'Username', with: user.username
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end
end
