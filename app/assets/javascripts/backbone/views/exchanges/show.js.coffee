class Sayings.Views.ShowExchange extends Backbone.View
  className: 'exchange'

  events:
    'click .back-link a': 'showPreviousExchange'

  initialize: ->
    _.bindAll( this, 'render', 'addUsernames', 'addEntries', 'addEntry', 'addResponder', 'setCurrentComment' )
    @model.entries.on 'add', @render
    @model.on 'change', @render

  render: ->
    $( @el ).html JST['backbone/templates/exchanges/show']
    @addUsernames()
    @addEntries()
    @addResponder() if Sayings.currentUser and Sayings.currentUser.id in @model.get 'ordered_user_ids'
    @addParentLink()
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

  addParentLink: ->
    if @model.get 'parent_exchange_id'
      $( '#back-link' ).html '<a href="#e/' + @model.get( 'parent_exchange_id' ) + '/' + @model.get( 'parent_entry_id' ) + '/' + @model.get( 'parent_comment_id' ) + '">back</a>'
      $( '#back-link a' ).on 'click', 'showPreviousExchange'
      $( '#back-link' ).show()
    else
      $( '#back-link' ).hide()

  expandComments: ( entryView ) ->
    entryView.model.comments.each @setCurrentComment
    entryView.showComments()

  setCurrentComment: ( comment ) ->
    if comment.id == @options.commentId
      comment.set 'current', true
    else
      comment.set 'current', false

  showPreviousExchange: ->
    previousUrl = 'e/' + @model.get( 'parent_exchange_id' ) + '/' + @model.get( 'parent_entry_id' ) + '/' + @model.get( 'parent_comment_id' )
    if @$el.prev().length > 0
      $previousExchange = @$el.prev()
      console.log $previousExchange
      width = $previousExchange.width()
      $previousExchange.show()
      $previousExchange.animate(
        { 'margin-left': '+=' + width },
        1000
      )
      Sayings.router.navigate previousUrl
      return false
