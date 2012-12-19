class Sayings.Routers.Exchanges extends Backbone.Router
  initialize: ( options ) ->
    _.bindAll this, 'index', 'show', 'renderExchange'
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
    exchange = @collection.get( exchangeId ) ? @fetchAndLoadExchange exchangeId
    view = new Sayings.Views.ShowExchange model: exchange, entryId: entryId, commentId: commentId
    @renderExchange view, commentId?

  fetchAndLoadExchange: ( exchangeId ) ->
    exchange = new Sayings.Models.Exchange _id: exchangeId
    @collection.add exchange
    exchange.fetch()

  renderExchange: ( view, renderFromLeft ) ->
    if renderFromLeft
      @exchangeManager.addFromLeft view
    else
      @exchangeManager.addFromRight view
