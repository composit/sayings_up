class Sayings.Views.CommentsIndex extends Backbone.View
  className: 'comments'

  initialize: ->
    _.bindAll( this, 'render', 'addComments', 'addComment', 'newComment' )
    @listenTo @collection, 'add', @render
    @listenTo @collection, 'change', @render

  render: ->
    $( @el ).html ''
    @addComments()
    @newComment() if Sayings.currentUser and Sayings.currentUser.get 'username'
    return this

  addComments: ->
    @collection.each @addComment

  addComment: ( comment ) ->
    commentView = new Sayings.Views.ShowComment model: comment
    $( @el ).append commentView.render().el

  newComment: ->
    newCommentView = new Sayings.Views.NewComment collection: @collection
    $( @el ).append newCommentView.render().el
