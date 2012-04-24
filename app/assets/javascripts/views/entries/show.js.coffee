class Sayings.Views.ShowEntry extends Backbone.View
  className: 'entry'

  initialize: ->
    _.bindAll( this, 'render', 'showComments', 'markCurrent' )
    @model.on 'change:current', @render

  events:
    'click .show-comments': 'showComments'

  render: ->
    $( @el ).html JST['entries/show'] @model
    @$( '.content' ).html @model.get 'content'
    if @model.get 'current'
      $( @el ).addClass 'current'
    else
      $( @el ).removeClass 'current'
    return this

  showComments: ->
    @model.collection.each @markCurrent
    commentsView = new Sayings.Views.CommentsIndex collection: @model.comments
    $( @el ).parents( '.exchange' ).find( '.comment-area' ).html commentsView.render().el
    return false

  markCurrent: ( entry ) ->
    if entry.id == @model.id
      entry.set 'current', true
    else
      entry.set 'current', false
