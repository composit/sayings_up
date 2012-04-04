class Sayings.Views.ShowExchange extends Backbone.View
  className: 'exchange'

  initialize: ->
    _.bindAll( this, 'addEntries', 'addEntry', 'addResponder' )
    @model.on "change", @render
   
  render: ->
    $( @el ).html JST['exchanges/show'] @model

    @addEntries()
    @addResponder() if Sayings.currentUser and Sayings.currentUser.id in @model.get 'ordered_user_ids'
    return this

  addEntries: ->
    @model.entries.each @addEntry

  addEntry: ( entry ) ->
    entryView = new Sayings.Views.ShowEntry { model: entry }
    @$( '#entries' ).append entryView.render().el

  addResponder: ->
    newEntryView = new Sayings.Views.NewEntry { collection: @model.entries }
    @$( '#entries' ).append newEntryView.render().el


  #addEntry: (entry) ->
  #  entryView = new Sayings.Views.ShowEntry( { model: entry } )
