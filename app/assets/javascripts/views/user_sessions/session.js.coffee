class Sayings.Views.UserSession extends Backbone.View
  id: 'session'

  events:
    'click #sign-in-link': 'new'
    'submit form#sign-in-form': 'save'

  initialize: ->
    _.bindAll( this, 'render', 'save' )

  render: ->
    $( @el ).html '<a href="#signin" id="sign-in-link">Sign in</a><a href="#signup">Sign up</a>'
    return this

  new: ( e )->
    $( @el ).html JST['user_sessions/new']
    return false

  save: ( e ) ->
    @model.save(
      { username: $( @el ).find( '#username' ).val(), password: $( @el ).find( '#password' ).val() }
      success: @saved
      error: @errored
    )
    return false

  saved: ( model, response ) ->

  errored: ( model, response ) ->
