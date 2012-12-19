class Sayings.Views.NewUser extends Backbone.View
  id: 'user'

  events:
    'submit form': 'save'

  initialize: ->
    _.bindAll( this, 'render', 'save', 'saved', 'errored' )

  render: ->
    $( @el ).html JST['backbone/templates/users/new']
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
    sessionView = new Sayings.Views.UserSession model: new Sayings.Models.UserSession model
    $( '#account' ).html sessionView.render().el
    sessionView.saved model
    @$el.remove()

  errored: ( xhr ) ->
    errorString = "<div class='validation-errors'>"
    _.each JSON.parse( xhr.responseText ).errors, ( error, field ) ->
      errorString += "<div class='error'>" + field + " " + error + "</div>"
    errorString += "</div>"
    @$( '.messages' ).prepend errorString
