class Sayings.Views.NewUser extends Backbone.View
  template: JST['users/new']
  id: 'user'

  events:
    "submit form": "save"

  render: ->
    $( @el ).html @template( @model )
    return this

  save: ( e ) ->
    console.log Sayings.users
    @model.collection = Sayings.users
    console.log @model
    console.log @model.url()
    @model.save( { username: "good", password: "password", password_confirmation: "password" }, { success: @saved } )
    return false

  saved: ->
    alert "goodness"
