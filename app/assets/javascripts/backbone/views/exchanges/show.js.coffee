class Sayings.Views.ShowExchange extends Support.CompositeView
  className: 'exchange'

  initialize: ->
    _.bindAll( this, 'render', 'addEntries', 'addEntry', 'addResponder', 'setCurrentComment' )
    @model.entries.on 'add', @render
    @model.entries.on 'showedComments', @moveToLeft
    @model.on 'change', @render

  render: ->
    $( @el ).html JST['backbone/templates/exchanges/show']
    @addEntries()
    @addResponder() if Sayings.currentUser and Sayings.currentUser.id in @model.get 'ordered_user_ids'
    return this

  addEntries: ->
    @model.entries.each @addEntry

  addEntry: ( entry ) ->
    entryView = new Sayings.Views.ShowEntry model: entry
    $entryEl = $( entryView.render().el )
    if entry.get( 'user_id' ) == @model.get( 'ordered_user_ids' )[0]
      $entryEl.addClass 'first-user'
    else
      $entryEl.addClass 'second-user'
    @$( '.entries' ).append $entryEl
    entryView.markCurrent unless @$( '.entries' ).find( '.entry' ).length > 1
    @expandComments( entryView ) if entry.id == @options.entryId

  addResponder: ->
    newEntryView = new Sayings.Views.NewEntry collection: @model.entries
    @$( '.entries' ).append newEntryView.render().el

  expandComments: ( entryView ) ->
    entryView.model.comments.each @setCurrentComment
    entryView.showComments()

  setCurrentComment: ( comment ) ->
    if comment.id == @options.commentId
      comment.set 'current', true
    else
      comment.set 'current', false

  orderedLeave: ->
    @parent.orderedChildren.splice( @parent.orderedChildren.indexOf( this ), 1 )
    @leave()

  #TODO move into manager
  moveToLeft: =>
    if @parent
      if @parent && @parent.orderedChildren.first().model == @model
        @parent.removeRightOfExchange @model
      else
        @parent.removeFromLeft 1
