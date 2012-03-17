class Sayings.Views.NewUser extends Backbone.View
  template: JST['users/new']
  id: 'user'

  render: ->
    $( this.el ).html( @template )
