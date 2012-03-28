class Sayings.Views.UserSession extends Backbone.View
  id: 'session'

  events:
    'click #sign-in-link': 'new'
    'submit form#sign-in-form': 'save'
    'click #sign-out-link': 'destroy'

  initialize: ->
    _.bindAll( this, 'render', 'save', 'saved', 'errored', 'destroyed' )

  render: ->
    if( @model && !@model.isNew() )
      @saved( @model )
    else
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
    @$el.html "<div class='messages'><div class='notice'>Welcome back, " + model.get( 'username' ) + "</div></div>"
    @$el.append '<a href="#signout" id="sign-out-link">Sign out</a>'

  errored: ( model, response ) ->
    errorString = "<div class='validation-errors'>"
    _.each JSON.parse( response.responseText ).errors, ( error, field ) ->
      errorString += "<div class='error'>" + field + " " + error + "</div>"
    errorString += "</div>"
    @$el.find( '.messages' ).prepend errorString

  destroy: ( e ) ->
    @model.destroy(
      success: @destroyed
    )
    return false

  destroyed: ( model, response ) ->
    @model = new Sayings.Models.UserSession()
    @render()
    $( @el ).prepend "<div class='notice'>You are signed out</div>"
