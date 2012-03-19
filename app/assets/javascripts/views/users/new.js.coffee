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
    @model.save( { username: "good", password: "password", password_confirmation: "password" }, { success: @saved } )
    return false

  saved: ->
    alert "goodness"
