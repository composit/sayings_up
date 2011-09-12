class SayingsUp.Routers.ExchangesRouter extends Backbone.Router
  initialize: (options) ->
    @exchanges = new SayingsUp.Collections.ExchangesCollection()
    @exchanges.reset options.exchanges

  routes:
    "/new"      : "newExchange"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newExchange: ->
    @view = new SayingsUp.Views.Exchanges.NewView(collection: @exchanges)
    $("#exchanges").html(@view.render().el)

  index: ->
    @view = new SayingsUp.Views.Exchanges.IndexView(exchanges: @exchanges)
    $("#exchanges").html(@view.render().el)

  show: (id) ->
    exchange = @exchanges.get(id)
    
    @view = new SayingsUp.Views.Exchanges.ShowView(model: exchange)
    $("#exchanges").html(@view.render().el)
    
  edit: (id) ->
    exchange = @exchanges.get(id)

    @view = new SayingsUp.Views.Exchanges.EditView(model: exchange)
    $("#exchanges").html(@view.render().el)
  
