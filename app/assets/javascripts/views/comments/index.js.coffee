class Sayings.Views.CommentsIndex extends Backbone.View
  className: 'comments'

  initialize: ->
    _.bindAll( this, 'render', 'addComments', 'addComment', 'newComment' )
    @collection.on 'add', @render

  render: ->
    $( @el ).html JST['comments/index']
    @addComments()
    @newComment() if Sayings.currentUser and Sayings.currentUser.id
    return this

  addComments: ->
    @collection.each @addComment

  addComment: ( comment ) ->
    commentView = new Sayings.Views.ShowComment { model: comment }
    @$( '.comments' ).append commentView.render().el

  newComment: ->
    newCommentView = new Sayings.Views.NewComment { collection: @collection }
    @$( '.comments' ).append newCommentView.render().el
