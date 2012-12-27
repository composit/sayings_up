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
    numberToRemove = @orderedChildren.size() - 2
    firstViewElement.animate { 'margin-left': '0px' }, 500, () =>
      @removeFromRight numberToRemove

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
        @orderedChildren.first().orderedLeave()
        @removeFromLeft threshold

  removeFromRight: ( numberToRemove ) ->
    if numberToRemove > 0
      for num in [1..numberToRemove]
        @orderedChildren.last().orderedLeave()
