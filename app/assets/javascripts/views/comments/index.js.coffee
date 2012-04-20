class Sayings.Views.CommentsIndex extends Backbone.View
  className: 'comments'

  initialize: ->
    _.bindAll( this, 'render', 'addComments', 'addComment', 'newComment' )
    @collection.on 'add', @render
    @collection.on 'change', @render

  render: ->
    $( @el ).html ''
    @addComments()
    @newComment() if Sayings.currentUser and Sayings.currentUser.id
    return this

  addComments: ->
    @collection.each @addComment

  addComment: ( comment ) ->
    commentView = new Sayings.Views.ShowComment model: comment
    $( @el ).append commentView.render().el

  newComment: ->
    newCommentView = new Sayings.Views.NewComment collection: @collection
    $( @el ).append newCommentView.render().el
