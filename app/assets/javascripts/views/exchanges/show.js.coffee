class Sayings.Views.ShowExchange extends Backbone.View
  className: 'exchange'

  initialize: ->
    _.bindAll( this, 'render', 'addEntries', 'addEntry', 'addResponder' )
    @model.entries.on 'add', @render

  render: ->
    $( @el ).html JST['exchanges/show'] @model
    @addEntries()
    @addResponder() if Sayings.currentUser and Sayings.currentUser.id in @model.get 'ordered_user_ids'
    @addParentLink() if @model.get 'parent_exchange_id'
    return this

  addEntries: ->
    @model.entries.each @addEntry

  addEntry: ( entry ) ->
    commentId = @options.commentId if entry.id == @options.entryId
    entryView = new Sayings.Views.ShowEntry model: entry, commentId: commentId
    @$( '.entries' ).append entryView.render().el

  addResponder: ->
    newEntryView = new Sayings.Views.NewEntry collection: @model.entries
    @$( '.entries' ).append newEntryView.render().el

  addParentLink: ->
    $( @el ).prepend '<a href="#e/' + @model.get( 'parent_exchange_id' ) + '/' + @model.get( 'parent_entry_id' ) + '/' + @model.get( 'parent_comment_id' ) + '">back</a>'
