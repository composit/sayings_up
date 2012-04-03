class Sayings.Views.ShowExchange extends Backbone.View
  className: 'exchange'
   
  render: ->
    $( @el ).html JST['exchanges/show'] @model

    self = this
    @model.entries.each ( entry ) ->
      entryView = new Sayings.Views.ShowEntry { model: entry }
      self.$( '#entries' ).append entryView.render().el
    if Sayings.currentUser and Sayings.currentUser.id in @model.get 'user_ids'
      newEntry = new Sayings.Models.Entry()
      newEntryView = new Sayings.Views.NewEntry { model: newEntry }
      self.$( '#entries' ).append newEntryView.render().el
    return this

  #addEntry: (entry) ->
  #  entryView = new Sayings.Views.ShowEntry( { model: entry } )
