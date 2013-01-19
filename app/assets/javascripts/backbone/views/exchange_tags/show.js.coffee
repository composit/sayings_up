class Sayings.Views.ShowExchangeTag extends Support.CompositeView
  tagName: 'span'
  className: 'exchange-tag'

  render: ->
    @$el.html JST['backbone/templates/exchange_tags/show']
    @$( '.tag_name' ).html @model.get 'tag_name'
    return this
