#= require_self
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

window.SayingsUp =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->
    new SayingsUp.Routers.Exchanges()
    @exchanges = new SayingsUp.Collections.Exchanges( exchanges )
    Backbone.history.start()
