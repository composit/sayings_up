class Sayings.Views.ShowExchangeTag extends Support.CompositeView
  tagName: 'span'
  className: 'exchange-tag'

  events:
    'click .add-tag-link': 'addToTag'
    'click .remove-tag-link': 'removeFromTag'

  render: ->
    @$el.html JST['backbone/templates/exchange_tags/show']
    @$( '.tag_name' ).html @model.get 'tag_name'
    if Sayings.currentUserSession and Sayings.currentUserSession.get 'user_id'
      if @model.get 'current_user_tagging_id'
        @$( '.actions' ).html '<a class="remove-tag-link" href="#">-</a>'
      else
        @$( '.actions' ).html '<a class="add-tag-link" href="#">+</a>'
    return this

  addToTag: ->
    @model.save(
      {}
      success: @saved
    )
    return false

  saved: ( model ) =>
    @collection.addOrOwn model

  removeFromTag: ->
    $.ajax(
      url: @model.url()
      type: 'DELETE'
      success: @removed
    )
    return false

  removed: =>
    @collection.removeOrDisown @model
