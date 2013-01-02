class Sayings.Views.ShowEntry extends Backbone.View
  className: 'entry'

  initialize: ->
    _.bindAll( this, 'render', 'showComments', 'markCurrent' )
    @listenTo @model, 'change:current', @render
    @listenTo @model.comments, 'add', @render

  events:
    'click .show-comments': 'expandComments'

  render: ->
    $( @el ).html JST['backbone/templates/entries/show'] @model
    @$( '.content' ).html @model.get 'content'
    @$( '.username' ).html @model.get 'username'
    @$( '.show-comments' ).html @model.comments.length + ' comments'
    if @model.get 'current'
      $( @el ).addClass 'current'
    else
      $( @el ).removeClass 'current'
    return this

  expandComments: ->
    @showComments()
    @model.collection.trigger 'showedComments'
    return false

  showComments: ->
    @model.collection.each @markCurrent
    commentsView = new Sayings.Views.CommentsIndex collection: @model.comments
    commentsEl = commentsView.render().el
    @$el.parents( '.exchange' ).find( '.comments-column' ).html commentsEl
    $( commentsEl ).css 'top', @$el.position().top - 18

  #TODO move into manager
  markCurrent: ( entry ) ->
    if entry.id == @model.id
      entry.set 'current', true
    else
      entry.set 'current', false
