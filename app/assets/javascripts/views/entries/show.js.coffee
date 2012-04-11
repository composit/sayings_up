class Sayings.Views.ShowEntry extends Backbone.View
  className: 'entry'

  initialize: ->
    _.bindAll( this, 'render', 'showComments' )

  events:
    'click .show-comments': 'showComments'

  render: ->
    $( @el ).html JST['entries/show'] @model
    @$( '.content' ).html @model.get 'content'
    return this

  showComments: ->
    commentsView = new Sayings.Views.CommentsIndex( { collection: @model.comments } )
    $( @el ).parents( '.exchange' ).append( commentsView.render().el )
    return false
