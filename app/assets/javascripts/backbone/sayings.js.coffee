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

  init: ( current_user_session, silent = false ) ->
    exchangesCollection = new Sayings.Collections.Exchanges []
    @currentUserSession = new Sayings.Models.UserSession current_user_session

    @router = new Sayings.Routers.Exchanges collection: exchangesCollection
    user_session = new Sayings.Routers.UserSessions model: @currentUserSession
    user_session.new()

    if !Backbone.history.started
      Backbone.history.start silent: silent
      Backbone.history.started = true
