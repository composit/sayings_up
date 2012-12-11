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
    commentsEl = commentsView.render().el
    @$el.parents( '.exchange' ).find( '.comments-column' ).html commentsEl
    $( commentsEl ).css 'top', @$el.position().top
    @removePreviousExchange()
    return false

  markCurrent: ( entry ) ->
    if entry.id == @model.id
      entry.set 'current', true
    else
      entry.set 'current', false

  removePreviousExchange: ->
    #$previousExchange = @$el.parents( '.exchange' ).prev()
    #width = $previousExchange.width()
    #$previousExchange.animate(
    #  { 'margin-left': '-=' + width },
    #  1000,
    #  () ->
    #    Sayings.router.exchangeManager.children.first().leave()
    #    #$previousExchange.hide()
    #)
    if Sayings.router.exchangeManager.orderedChildren.size() > 1
      Sayings.router.exchangeManager.orderedChildren.first().orderedLeave()
