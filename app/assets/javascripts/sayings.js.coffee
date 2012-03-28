window.Sayings =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ( exchanges, current_user, silent = false ) ->
    @exchanges = new Sayings.Collections.Exchanges( exchanges )
    @currentUser = new Sayings.Models.UserSession( current_user )

    new Sayings.Routers.Exchanges( { collection: @exchanges } )
    new Sayings.Routers.Users( { collection: new Sayings.Collections.Users() } )
    new Sayings.Routers.UserSessions( { model: @currentUser } )

    if !Backbone.history.started
      Backbone.history.start( { silent: silent } )
      Backbone.history.started = true
