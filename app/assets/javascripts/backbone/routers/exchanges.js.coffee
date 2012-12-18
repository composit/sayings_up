class Sayings.Routers.Exchanges extends Backbone.Router
  initialize: ( options ) ->
    _.bindAll( this, 'index', 'show', 'renderExchange' )
    @collection = options.collection
    @exchangeManager = new Sayings.Views.ExchangeManager
    $( '#exchanges' ).html @exchangeManager.render().el

  routes:
    '': 'index'
    'e/:id/:entryId/:commentId': 'show'
    'e/:id': 'show'

  index: ->
    view = new Sayings.Views.ExchangesIndex collection: @collection
    $( '#exchanges' ).html view.render().el

  show: ( exchangeId, entryId, commentId ) ->
    if exchange = @collection.get exchangeId
      @renderExchange exchange, entryId, commentId
    else
      @fetchAndRenderExchange exchangeId, entryId, commentId

  renderExchange: ( exchange, entryId, commentId ) ->
    @view = new Sayings.Views.ShowExchange model: exchange, entryId: entryId, commentId: commentId
    if commentId
      @exchangeManager.addFromLeft @view
    else
      @exchangeManager.addFromRight @view

  fetchAndRenderExchange: ( exchangeId, entryId, commentId ) ->
    exchange = new Sayings.Models.Exchange _id: exchangeId
    @collection.add exchange
    exchange.fetch(
      success: =>
        exchange.parseEntries()
        @renderExchange exchange, entryId, commentId
    )
