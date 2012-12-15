class Sayings.Views.ShowExchange extends Support.CompositeView
  className: 'exchange'

  initialize: ->
    _.bindAll( this, 'render', 'addUsernames', 'addEntries', 'addEntry', 'addResponder', 'setCurrentComment' )
    @model.entries.on 'add', @render
    @model.entries.on 'showedComments', @moveToLeft
    @model.on 'change', @render

  render: ->
    $( @el ).html JST['backbone/templates/exchanges/show']
    @addUsernames()
    @addEntries()
    @addResponder() if Sayings.currentUser and Sayings.currentUser.id in @model.get 'ordered_user_ids'
    return this

  addUsernames: ->
    @$( '.first-username' ).html( @model.get( 'ordered_usernames' )[0] ) unless typeof @model.get( 'ordered_usernames' )[0] == 'undefined'
    @$( '.second-username' ).html( @model.get( 'ordered_usernames' )[1] ) unless typeof @model.get( 'ordered_usernames' )[1] == 'undefined'

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

  moveToLeft: =>
    if @parent && @parent.orderedChildren.first().model != @model
      @parent.removeFromLeft 1
