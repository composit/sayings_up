class Sayings.Views.UserSession extends Backbone.View
  template: JST['users/session']
  id: 'session'

  events:
    'click #sign-in': 'new'

  render: ->
    $( @el ).html '<a href="#signin" id="sign-in">Sign in</a><a href="#signup">Sign up</a>'
    return this

  new: ->
    $( @el ).html JST['user_sessions/new']
    return false
