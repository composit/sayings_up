class Sayings.Routers.Exchanges extends Backbone.Router
  initialize: ( options ) ->
    _.bindAll( this, 'index', 'show', 'renderExchange' )
    @collection = options.collection

  routes:
    '': 'index'
    'e/:id': 'show'

  index: ->
    view = new Sayings.Views.ExchangesIndex collection: @collection
    $( '#exchanges' ).html view.render().el

  show: ( id ) ->
    if exchange = @collection.get id
      @renderExchange exchange
    else
      exchange = new Sayings.Models.Exchange _id: id
      @collection.add exchange
      exchange.fetch(
        success: =>
          exchange.parseEntries()
          @renderExchange( exchange )
      )
   

  renderExchange: ( exchange ) ->
    view = new Sayings.Views.ShowExchange model: exchange
    $( '#exchanges' ).html view.render().el
