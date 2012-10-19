class Sayings.Views.ShowEntry extends Backbone.View
  className: 'entry'

  initialize: ->
    _.bindAll( this, 'render', 'showComments', 'markCurrent' )
    @model.on 'change:current', @render

  events:
    'click .show-comments': 'showComments'

  render: ->
    $( @el ).html JST['backbone/templates/entries/show'] @model
    @$( '.content' ).html @model.get 'content'
    @$( '.username' ).html @model.get 'user_username'
    @$( '.show-comments' ).html @model.comments.length + ' comments'
    if @model.get 'current'
      $( @el ).addClass 'current'
    else
      $( @el ).removeClass 'current'
    return this

  showComments: ->
    @model.collection.each @markCurrent
    commentsView = new Sayings.Views.CommentsIndex collection: @model.comments
    $( '#comments-column' ).find( '.comments' ).last().remove()
    $( '#comments-column' ).append commentsView.render().el
    return false

  markCurrent: ( entry ) ->
    if entry.id == @model.id
      entry.set 'current', true
    else
      entry.set 'current', false
