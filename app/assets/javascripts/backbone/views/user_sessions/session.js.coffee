class Sayings.Views.UserSession extends Backbone.View
  id: 'session'

  initialize: ->
    _.bindAll( this, 'render', 'save', 'saved', 'errored', 'destroyed' )

  events:
    'submit form#sign-in-form': 'save'
    'click #sign-out-link': 'destroy'

  render: ->
    if( @model && @model.get( 'user_id' )? )
      @saved( @model )
    else
      $( @el ).html JST['backbone/templates/user_sessions/new']
    return this

  save: ( e ) ->
    @$( ".messages" ).html ''
    @model.save(
      { username: @$( '#username' ).val(), password: @$( '#password' ).val() }
      success: @saved
      error: @errored
    )
    return false

  saved: ( model ) ->
    Sayings.currentUserSession = model
    @$el.html "<div class='messages'><div class='notice'>Welcome, " + model.get( 'username' ) + "</div></div>"
    @$el.append '<a href="#signout" id="sign-out-link">Sign out</a>'
    model.trigger 'loginStateChanged'

  errored: ( xhr ) ->
    errorString = "<div class='validation-errors'>"
    _.each JSON.parse( xhr.responseText ).errors, ( error, field ) ->
      errorString += "<div class='error'>" + field + " " + error + "</div>"
    errorString += "</div>"
    @$( '.messages' ).prepend errorString

  destroy: ( e ) ->
    @model.destroy(
      success: @destroyed
    )
    return false

  destroyed: ( model, response ) ->
    @model = new Sayings.Models.UserSession()
    Sayings.currentUserSession = @model
    model.trigger 'loginStateChanged'
    @render()
    $( @el ).prepend "<div class='notice'>You are signed out</div>"
    Sayings.exchange.trigger 'change' if Sayings.exchange
