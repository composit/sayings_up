class Sayings.Routers.Exchanges extends Backbone.Router
  #initialize: (options) ->
  #  @exchanges = new Sayings.Collections.Exchanges
  #  @exchanges.reset @collection

  routes:
    #"/new"      : "newExchange"
    #"/:id/edit" : "edit"
    #"/:id"      : "show"
    ".*"        : "index"

  #newExchange: ->
  #  @view = new Sayings.Views.NewExchange(collection: @exchanges)
  #  $("#exchanges").html(@view.render().el)

  index: ->
    view = new Sayings.Views.ExchangesIndex( { collection: Sayings.exchanges } )
    $( "#exchanges" ).html( view.render().el )

  #show: ( id ) ->
  #  exchange = @exchanges.get( id )
    
  #@view = new Sayings.Views.Exchange( model: exchange )
  #$( "#exchanges" ).html( @view.render().el )
    
  #edit: (id) ->
  #  exchange = @exchanges.get(id)

  #  @view = new Sayings.Views.EditExchange(model: exchange)
  #  $("#exchanges").html(@view.render().el)
