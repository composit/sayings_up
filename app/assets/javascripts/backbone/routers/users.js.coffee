class Sayings.Routers.Users extends Backbone.Router
  initialize: ( options ) ->
    @collection = options.collection

  routes:
    'signup': 'new'

  new: ->
    view = new Sayings.Views.NewUser( { model: new @collection.model } )
    $( '#header' ).after( view.render().el )
