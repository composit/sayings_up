#= require_self
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

window.Sayings =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ( exchanges ) ->
    new Sayings.Routers.Exchanges()
    @exchanges = new Sayings.Collections.Exchanges( exchanges )
    Backbone.history.start()
