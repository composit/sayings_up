window.Sayings =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ( exchanges, silent = false ) ->
    @exchanges = new Sayings.Collections.Exchanges( exchanges )

    new Sayings.Routers.Exchanges( { collection: @exchanges } )

    if !Backbone.history.started
      Backbone.history.start( { silent: silent } )
      Backbone.history.started = true
