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
      Sayings.router.navigate '#e/' + earliestExchange.get( 'parent_exchange_id' ) + '/' + earliestExchange.get( 'parent_entry_id' ) + '/' + earliestExchange.get( 'parent_comment_id' )
      Sayings.router.show earliestExchange.get( 'parent_exchange_id' ), earliestExchange.get( 'parent_entry_id' ), earliestExchange.get( 'parent_comment_id' )
    return false

  addFromLeft: ( exchangeView ) ->
    @prependChildTo exchangeView, $( '#exchange-children' )
    @orderedChildren.unshift exchangeView
    if @orderedChildren.size() > 2
      @orderedChildren.last().orderedLeave()

  addFromRight: ( exchangeView ) ->
    @appendChildTo exchangeView, $( '#exchange-children' )
    @orderedChildren.push exchangeView
    if @orderedChildren.size() > 2
      @orderedChildren.first().orderedLeave()
