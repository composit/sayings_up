class Sayings.Views.NewUser extends Backbone.View
  template: JST['users/new']
  id: 'user'

  events:
    "submit form": "save"

  render: ->
    $( @el ).html @template( @model )
    return this

  save: ( e ) ->
    @model.collection = new Sayings.Collections.Users()
    @model.save( { username: $( "#username" ).val(), password: $( "#password" ).val(), password_confirmation: $( "password_confirmation" ).val() }, { success: @saved } )
    return false

  saved: ->
    console.log @$el
    $( @el ).html( "<h2>Thanks for signing up!</h2>" )
    return this
