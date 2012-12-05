class Sayings.Routers.Exchanges extends Backbone.Router
  initialize: ( options ) ->
    _.bindAll( this, 'index', 'show', 'renderExchange' )
    @collection = options.collection

  routes:
    '': 'index'
    'e/:id/:entryId/:commentId': 'show'
    'e/:id': 'show'

  index: ->
    view = new Sayings.Views.ExchangesIndex collection: @collection
    $( '#exchanges' ).html view.render().el

  show: ( id, entryId, commentId ) ->
    console.log 'here'
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
    Sayings.exchange = exchange
    @view = new Sayings.Views.ShowExchange model: exchange, entryId: entryId, commentId: commentId
    @$el = $( @view.render().el )
    if commentId
      $( '#exchanges' ).prepend @$el
    else
      $( '#exchanges' ).append @$el
