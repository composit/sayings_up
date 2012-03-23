class Sayings.Views.UserSession extends Backbone.View
  template: JST['users/session']
  id: 'session'

  render: ->
    $( @el ).html '<a href="#signin">Sign in</a><a href="#signup">Sign up</a>'
    return this
