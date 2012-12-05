#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Sayings =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  init: ( exchanges, current_user, silent = false ) ->
    @exchanges = new Sayings.Collections.Exchanges( exchanges )
    @currentUser = new Sayings.Models.UserSession( current_user )

    Sayings.router = new Sayings.Routers.Exchanges( { collection: @exchanges } )
    new Sayings.Routers.Users( { collection: new Sayings.Collections.Users() } )
    user_session = new Sayings.Routers.UserSessions( { model: @currentUser } )
    user_session.new()

    if !Backbone.history.started
      Backbone.history.start( { silent: silent } )
      Backbone.history.started = true
