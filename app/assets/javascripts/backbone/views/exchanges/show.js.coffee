class Sayings.Views.ShowExchange extends Support.CompositeView
  className: 'exchange'

  initialize: ->
    _.bindAll( this, 'render', 'addEntries', 'addEntry', 'addResponder', 'setCurrentComment' )
    @listenTo @model.entries, 'add', @render
    @listenTo @model.entries, 'showedComments', @isolate
    @listenTo @model, 'change', @render
    @listenTo @model, 'sync', @render
    @listenTo Sayings.currentUserSession, 'loginStateChanged', @render
    @listenTo Sayings.currentUserSession, 'destroy', @render

  render: ->
    @$el.html JST['backbone/templates/exchanges/show']
    @addEntries()
    @addResponder() if Sayings.currentUserSession and Sayings.currentUserSession.get( 'user_id' ) in @model.get 'ordered_user_ids'
    @addExchangeTags()
    return this

  addEntries: ->
    @model.entries.each @addEntry

  addEntry: ( entry ) ->
    entryView = new Sayings.Views.ShowEntry model: entry
    $entryEl = entryView.render().$el
    if entry.get( 'user_id' ) == @model.get( 'ordered_user_ids' )[0]
      $entryEl.addClass 'first-user'
    else
      $entryEl.addClass 'second-user'
    @$( '.entries' ).append $entryEl
    entryView.markCurrent unless @$( '.entries' ).find( '.entry' ).length > 1
    @expandComments( entryView ) if entry.id == @options.entryId

  addExchangeTags: =>
    exchangeTagsView = new Sayings.Views.ExchangeTagsIndex collection: @model.exchangeTags
    @$( '.exchange-tags' ).append exchangeTagsView.render().$el

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

  isolate: =>
    @parent.isolate( this ) if @parent
