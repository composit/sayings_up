class Sayings.Routers.Exchanges extends Backbone.Router
  initialize: ( options ) ->
    _.bindAll this, 'index', 'show', 'renderExchange'
    @collection = options.collection

  routes:
    '': 'index'
    'e/:exchangeId/:entryId/:commentId': 'show'
    'e/:exchangeId': 'show'

  index: ->

  show: ( exchangeId, entryId, commentId ) ->
    @renderManager() unless @exchangeManager?
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

  renderManager: ->
    @exchangeManager = new Sayings.Views.ExchangeManager
    $( '#exchanges' ).html @exchangeManager.render().el
