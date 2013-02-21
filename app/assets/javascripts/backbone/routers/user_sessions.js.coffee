class Sayings.Routers.UserSessions extends Backbone.Router
  initialize: ( options ) ->
    @model = options.model

  routes:
    'login': 'new'

  new: ->
    view = new Sayings.Views.UserSession( { model: @model } )
    $( '#account' ).prepend( view.render().el )
