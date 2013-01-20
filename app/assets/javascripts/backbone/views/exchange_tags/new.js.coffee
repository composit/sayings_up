class Sayings.Views.NewExchangeTag extends Backbone.View
  id: 'new-exchange-tag'
  tagName: 'span'

  events:
    'click #new-exchange-tag-link': 'new'
    'submit form#new-exchange-tag-form': 'save'

  render: ->
    @$el.html '<a id="new-exchange-tag-link" href="#">+new tag</a>'
    return this

  new: ->
    @model = new Sayings.Models.ExchangeTag()
    @model.collection = @collection
    @$el.html JST['backbone/templates/exchange_tags/new']
    return false

  save: ->
    @model.save(
      { tag_name: @$( '#tag_name' ).val() }
      success: @saved
    )
    return false

  saved: ( model ) =>
    @collection.add model
