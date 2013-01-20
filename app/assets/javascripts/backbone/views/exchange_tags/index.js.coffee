class Sayings.Views.ExchangeTagsIndex extends Support.CompositeView
  initialize: ->
    @listenTo @collection, 'add', @render
    @listenTo @collection, 'change', @render

  render: ->
    @$el.html ''
    @addExchangeTags()
    @newExchangeTag() if Sayings.currentUserSession and Sayings.currentUserSession.get 'user_id'
    return this

  addExchangeTags: ->
    @collection.each @addExchangeTag

  addExchangeTag: ( exchangeTag ) =>
    exchangeTagView = new Sayings.Views.ShowExchangeTag model: exchangeTag, collection: @collection
    @$el.append exchangeTagView.render().el

  newExchangeTag: ->
    newExchangeTagView = new Sayings.Views.NewExchangeTag collection: @collection
    @$el.append newExchangeTagView.render().el
