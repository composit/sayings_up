class Sayings.Views.CommentsIndex extends Backbone.View
  className: 'comments'

  initialize: ->
    _.bindAll( this, 'render', 'addComments', 'addComment' )

  render: ->
    $( @el ).html JST['comments/index']
    @addComments()
    return this

  addComments: ->
    @collection.each @addComment

  addComment: ( comment ) ->
    commentView = new Sayings.Views.ShowComment { model: comment }
    @$( '.comments' ).append commentView.render().el
