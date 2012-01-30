class SayingsUp.Routers.Exchanges extends Backbone.Router
  initialize: (options) ->
    @exchanges = new SayingsUp.Collections.Exchanges
    @exchanges.reset options.exchanges

  routes:
    "/new"      : "newExchange"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  #newExchange: ->
  #  @view = new SayingsUp.Views.Exchanges.New(collection: @exchanges)
  #  $("#exchanges").html(@view.render().el)

  index: ->
    @view = new SayingsUp.Views.Exchanges.Index( exchanges: @exchanges )
    $( "#exchanges" ).html( @view.render().el )

  show: ( id ) ->
    exchange = @exchanges.get( id )
    
    @view = new SayingsUp.Views.Exchanges.Show( model: exchange )
    $( "#exchanges" ).html( @view.render().el )
    
  #edit: (id) ->
  #  exchange = @exchanges.get(id)

  #  @view = new SayingsUp.Views.Exchanges.Edit(model: exchange)
  #  $("#exchanges").html(@view.render().el)
