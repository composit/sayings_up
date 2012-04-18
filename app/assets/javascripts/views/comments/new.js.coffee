class Sayings.Views.NewComment extends Backbone.View
  className: 'new-comment'

  initialize: ->
    _.bindAll( this, 'render', 'new', 'save', 'saved' )
    @model = new Sayings.Models.Comment()
    @model.collection = @collection

  events:
    'click #new-comment-link': 'new'
    'submit form#new-comment-form': 'save'

  render: ->
    $( @el ).html '<a id="new-comment-link" href="#">add comment</a>'
    return this

  new: ->
    $( @el ).html JST['comments/new']
    return false

  save: ->
    @model.save(
      { content: @$( '#content' ).val() }
      success: @saved
    )
    return false

  saved: ->
    @collection.add @model
