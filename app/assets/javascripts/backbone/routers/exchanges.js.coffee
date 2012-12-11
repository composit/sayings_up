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

  show: ( id, entryId, commentId ) ->
    if exchange = @collection.get id
      @renderExchange exchange, entryId, commentId
    else
      exchange = new Sayings.Models.Exchange _id: id
      @collection.add exchange
      exchange.fetch(
        success: =>
          exchange.parseEntries()
          @renderExchange exchange, entryId, commentId
      )

  renderExchange: ( exchange, entryId, commentId ) ->
    @view = new Sayings.Views.ShowExchange model: exchange, entryId: entryId, commentId: commentId
    if commentId
      @exchangeManager.addFromLeft @view
    else
      @exchangeManager.addFromRight @view
