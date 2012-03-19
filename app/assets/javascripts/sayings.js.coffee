window.Sayings =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ( exchanges, silent = false ) ->
    @exchanges = new Sayings.Collections.Exchanges( exchanges )
    @users = new Sayings.Collections.Users()

    new Sayings.Routers.Exchanges( { collection: @exchanges } )
    new Sayings.Routers.Users( { collection: @users } )

    if !Backbone.history.started
      Backbone.history.start( { silent: silent } )
      Backbone.history.started = true
