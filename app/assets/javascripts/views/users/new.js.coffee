class Sayings.Views.NewUser extends Backbone.View
  template: JST['users/new']
  id: 'user'

  events:
    'submit form': 'save'

  initialize: ->
    _.bindAll( this, 'render', 'save', 'saved', 'errored' )

  render: ->
    $( @el ).html @template( @model )
    return this

  save: ( e ) ->
    @$( ".messages" ).html ''
    @model.collection = new Sayings.Collections.Users()
    @model.save(
      { username: @$( "#username" ).val(), password: @$( "#password" ).val(), password_confirmation: @$( "#password_confirmation" ).val() }
      success: @saved
      error: @errored
    )
    return false

  saved: ( model, response ) ->
    @$( '.messages' ).prepend "<div class='notice'>Welcome, " + model.get( 'username' ) + "</div>"
    sessionView = new Sayings.Views.UserSession( { model: model } )
    $( '#account' ).html( sessionView.render().el )
    sessionView.saved( model )

  errored: ( model, response ) ->
    errorString = "<div class='validation-errors'>"
    _.each JSON.parse( response.responseText ).errors, ( error, field ) ->
      errorString += "<div class='error'>" + field + " " + error + "</div>"
    errorString += "</div>"
    @$( '.messages' ).prepend errorString
