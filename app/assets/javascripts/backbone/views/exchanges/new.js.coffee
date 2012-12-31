class Sayings.Views.NewExchange extends Backbone.View
  className: 'new-exchange'

  initialize: ->
    _.bindAll( this, 'render', 'new', 'save', 'saved' )
    @model.url = '/exchanges'

  events:
    'click .respond-link': 'new'
    'submit form#new-exchange-form': 'save'

  render: ->
    $( @el ).html '<a class="respond-link" href="#">respond</a>'
    return this

  new: ->
    $( @el ).html JST['backbone/templates/exchanges/new']
    return false

  save: ->
    if vals = @model.get 'initial_values'
      vals.content = @$( '#content' ).val()
      @model.set 'initial_values', vals
    @model.save(
      {}
      success: @saved
    )
    return false

  saved: ->
    @model.trigger 'sync'
    @options.parent_comment.set 'child_exchange_data', { id: @model.get( '_id' ), entry_count: @model.entries.length }
