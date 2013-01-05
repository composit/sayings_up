class Sayings.Views.ExchangeManager extends Support.CompositeView
  className: 'exchange-container'

  events:
    'click #back-link': 'goBack'

  initialize: ->
    @orderedChildren = _([])

  render: ->
    $( @el ).html JST['backbone/templates/exchanges/manager']
    return this

  goBack: ->
    if @orderedChildren.first()
      earliestExchange = @orderedChildren.first().model
      if earliestExchange.get 'parent_comment_id'
        Sayings.router.navigate '#e/' + earliestExchange.get( 'parent_exchange_id' ) + '/' + earliestExchange.get( 'parent_entry_id' ) + '/' + earliestExchange.get( 'parent_comment_id' )
        Sayings.router.showParent earliestExchange.get( 'parent_exchange_id' ), earliestExchange.get( 'parent_entry_id' ), earliestExchange.get( 'parent_comment_id' )
    return false

  addFromLeft: ( exchangeView ) ->
    @orderedChildren.unshift exchangeView
    @prependChildTo exchangeView, @$( '#exchange-children' )
    firstViewElement = $( exchangeView.el )
    firstViewElement.css 'margin-left', "-#{firstViewElement.css 'width'}"
    firstViewElement.css 'display', 'block'
    @removeFromRight @orderedChildren.size() - 2
    firstViewElement.animate { 'margin-left': '0px' }, 500
    if @orderedChildren.first().$el.find( '.entry.current' ).position() #TODO this conditional is only here to satisfy the test
      $( '.comments' ).first().css 'top', @orderedChildren.first().$el.find( '.entry.current' ).position().top - 18

  addToTheRightOf: ( exchangeView, parentExchange ) ->
    @removeRightOfExchange parentExchange
    @appearOnRight exchangeView

  removeRightOfExchange: ( exchange ) ->
    exchanges = @orderedChildren.pluck 'model'
    parentIndex = exchanges.indexOf exchange
    unless parentIndex == -1
      @removeFromRight exchanges.length - parentIndex - 1

  appearOnRight: ( exchangeView ) ->
    @orderedChildren.push exchangeView
    @appendChildTo exchangeView, @$( '#exchange-children' )
    $( exchangeView.el ).css 'display', 'block'
    @removeFromLeft 2

  removeFromLeft: ( threshold ) ->
    if @orderedChildren.size() > threshold
      firstViewElement = $( @orderedChildren.first().el )
      firstViewElement.animate { 'margin-left': "-#{firstViewElement.css 'width'}" }, 500, () =>
        @removeOrderedChild @orderedChildren.first()
        @removeFromLeft threshold

  removeFromRight: ( numberToRemove ) ->
    if numberToRemove > 0
      for num in [1..numberToRemove]
        @removeOrderedChild @orderedChildren.last()

  removeOrderedChild: ( exchangeView ) ->
    @orderedChildren.splice @orderedChildren.indexOf( exchangeView ), 1
    exchangeView.leave()

  isolate: ( exchangeView ) =>
    parentIndex = @orderedChildren.indexOf exchangeView
    @removeFromRight @orderedChildren.size() - parentIndex - 1
    @removeFromLeft 1
