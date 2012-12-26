class Sayings.Routers.Exchanges extends Backbone.Router
  initialize: ( options ) ->
    _.bindAll this, 'index', 'showChild', 'showParent', 'buildExchangeView'
    @collection = options.collection

  routes:
    '': 'index'
    'e/:exchangeId/:entryId/:commentId': 'showParent'
    'e/:exchangeId/:parentExchangeId': 'showChild'
    'e/:exchangeId': 'showChild'

  index: ->

  showChild: ( exchangeId, parentExchangeId ) ->
    view = @buildExchangeView exchangeId
    parentExchange = @collection.get parentExchangeId
    @exchangeManager.addToTheRightOf view, parentExchange

  showParent: ( exchangeId, entryId, commentId ) ->
    view = @buildExchangeView exchangeId, entryId, commentId
    @exchangeManager.addFromLeft view

  buildExchangeView: ( exchangeId, entryId, commentId ) ->
    @renderManager() unless @exchangeManager?
    exchange = @collection.get( exchangeId ) ? @fetchAndLoadExchange exchangeId
    return new Sayings.Views.ShowExchange model: exchange, entryId: entryId, commentId: commentId

  fetchAndLoadExchange: ( exchangeId ) ->
    exchange = new Sayings.Models.Exchange _id: exchangeId
    @collection.add exchange
    exchange.fetch()

  renderManager: ->
    @exchangeManager = new Sayings.Views.ExchangeManager
    $( '#exchanges' ).html @exchangeManager.render().el
