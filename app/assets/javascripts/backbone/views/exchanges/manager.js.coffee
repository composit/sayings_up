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
        Sayings.router.show earliestExchange.get( 'parent_exchange_id' ), earliestExchange.get( 'parent_entry_id' ), earliestExchange.get( 'parent_comment_id' )
    return false

  addFromLeft: ( exchangeView ) ->
    @orderedChildren.unshift exchangeView
    @slideFromLeft exchangeView

  addFromRight: ( exchangeView ) ->
    @orderedChildren.push exchangeView
    @appearOnRight exchangeView

  slideFromLeft: ( exchangeView ) ->
    @prependChildTo exchangeView, @$( '#exchange-children' )
    firstViewElement = $( exchangeView.el )
    firstViewElement.css 'margin-left', "-#{firstViewElement.css 'width'}"
    firstViewElement.css 'display', 'block'
    firstViewElement.animate { 'margin-left': '0px' }, 500, () =>
      @removeFromRight 2

  appearOnRight: ( exchangeView ) ->
    @appendChildTo exchangeView, @$( '#exchange-children' )
    $( exchangeView.el ).css 'display', 'block'
    @removeFromLeft 2

  removeFromLeft: ( threshold ) ->
    if @orderedChildren.size() > threshold
      firstViewElement = $( @orderedChildren.first().el )
      firstViewElement.animate { 'margin-left': "-#{firstViewElement.css 'width'}" }, 500, () =>
        @orderedChildren.first().orderedLeave()
        @removeFromLeft threshold

  removeFromRight: ( threshold ) ->
    @orderedChildren.last().orderedLeave() while @orderedChildren.size() > threshold
