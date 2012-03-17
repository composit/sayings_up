class Sayings.Views.NewUser extends Backbone.View
  template: JST['users/new']
  id: 'user'

  render: ->
    $( @el ).html @template( @model )
    return this
