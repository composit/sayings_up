class Sayings.Views.NewExchangeTag extends Backbone.View
  id: 'new-tag'

  events:
    'click #new-tag-link': 'new'

  render: ->
    @$el.html '<a id="new-tag-link" href="#">new tag</a>'
    return this

  new: ->
    @model = new Sayings.Models.ExchangeTag()
    @model.collection = @collection
    @$el.html JST['backbone/templates/exchange_tags/new']
    return false
