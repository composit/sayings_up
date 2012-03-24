class Sayings.Views.UserSession extends Backbone.View
  id: 'session'

  events:
    'click #sign-in-link': 'new'
    'submit form#sign-in-form': 'save'

  initialize: ->
    _.bindAll( this, 'render', 'save', 'saved', 'errored' )

  render: ->
    $( @el ).html '<a href="#signin" id="sign-in-link">Sign in</a><a href="#signup">Sign up</a>'
    return this

  new: ( e )->
    $( @el ).html JST['user_sessions/new']
    return false

  save: ( e ) ->
    $( @el ).find( ".messages" ).html ''
    @model.save(
      { username: $( @el ).find( '#username' ).val(), password: $( @el ).find( '#password' ).val() }
      success: @saved
      error: @errored
    )
    return false

  saved: ( model, response ) ->
    @$el.find( '.messages' ).prepend "<div class='notice'>Welcome back, " + model.get( 'username' ) + "</div>"

  errored: ( model, response ) ->
    errorString = "<div class='validation-errors'>"
    _.each JSON.parse( response.responseText ).errors, ( error, field ) ->
      errorString += "<div class='error'>" + field + " " + error + "</div>"
    errorString += "</div>"
    @$el.find( '.messages' ).prepend errorString
