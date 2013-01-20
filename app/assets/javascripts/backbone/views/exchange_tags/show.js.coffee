class Sayings.Views.ShowExchangeTag extends Support.CompositeView
  tagName: 'span'
  className: 'exchange-tag'

  render: ->
    @$el.html JST['backbone/templates/exchange_tags/show']
    @$( '.tag_name' ).html @model.get 'tag_name'
    @$( '.actions' ).html '<a class="remove-tag-link" href="#">-</a>' if @model.get 'owned_by_current_user'
    return this
