class Sayings.Views.NewEntry extends Backbone.View
  id: 'new-entry'

  initialize: ->
    _.bindAll( this, 'render', 'new', 'save', 'saved' )
    @model = new Sayings.Models.Entry()
    @model.collection = @collection

  events:
    'click #respond-link': 'new'
    'submit form#new-entry-form': 'save'

  render: ->
    $( @el ).html '<a id="respond-link" href="#">respond</a>'
    return this

  new: ->
    $( @el ).html JST['entries/new']
    return false

  save: ->
    @model.save(
      { content: @$( '#content' ).val() }
      success: @saved
    )
    return false

  saved: ->
    @collection.add @model
