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
    $previousComments = $( @el ).parents( '.exchange' ).find( '.comments' ).last()
    $( @el ).parents( '.exchange' ).find( '.comment-area' ).append commentsView.render().el
    distance = $previousComments.height() + 10
    $previousComments.animate { 'margin-top': '-' + distance + 'px' }, 1000, 'easeInOutQuart'
    return false

  markCurrent: ( entry ) ->
    if entry.id == @model.id
      entry.set 'current', true
    else
      entry.set 'current', false
