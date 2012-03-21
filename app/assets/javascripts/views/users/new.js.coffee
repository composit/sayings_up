class Sayings.Views.NewUser extends Backbone.View
  template: JST['users/new']
  id: 'user'

  events:
    "submit form": "save"

  initialize: () ->
    _.bindAll( this, 'render', 'save', 'saved', 'errored' )

  render: ->
    $( @el ).html @template( @model )
    return this

  save: ( e ) ->
    $( @el ).find( ".messages" ).html ''
    @model.collection = new Sayings.Collections.Users()
    @model.save(
      { username: $( @el ).find( "#username" ).val(), password: $( @el ).find( "#password" ).val(), password_confirmation: $( @el ).find( "#password_confirmation" ).val() }
      success: @saved
      error: @errored
    )
    return false

  saved: ( model, response ) ->
    @$el.find( '.messages' ).prepend "<div class='notice'>Welcome, " + model.get( 'username' ) + "</div>"
    $( '#account' ).html '<a href="#logout">Log out</a>'

  errored: ( model, response ) ->
    errorString = "<div class='validation-errors'>"
    _.each JSON.parse( response.responseText ).errors, ( error, field ) ->
      errorString += "<div class='error'>" + field + " " + error + "</div>"
    errorString += "</div>"
    @$el.find( '.messages' ).prepend errorString
