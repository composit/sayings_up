class Sayings.Routers.Users extends Backbone.Router
  initialize: ( options ) ->
    @collection = options.collection

  routes:
    'signup': 'new'

  new: ->
    view = new Sayings.Views.NewUser( { collection: @collection } )
    $( '#user' ).html( view.render().el )
