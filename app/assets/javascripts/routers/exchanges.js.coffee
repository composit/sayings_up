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
    $( '#entries-column' ).html view.render().el

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
    $previousExchange = $( '#entries-column .exchange' ).last()
    @$el = $( @view.render().el )
    if typeof entryId != 'undefined'
      distance = @$el.outerHeight true
      @$el.css( 'top', -1 * distance + 'px' )
      $( '#entries-column' ).prepend @$el
      #@$el.animate { 'top': 0 }, 1000, 'easeInOutQuart'
      $previousExchange.hide 'slow', -> $previousExchange.remove()
    else
      $previousExchange.css 'padding-bottom', 1000
      distance = $previousExchange.outerHeight true
      $( '#entries-column' ).append @$el
      $previousExchange.animate { 'margin-top': '-' + distance + 'px' }, 1000, 'easeInOutQuart', -> $previousExchange.remove()
