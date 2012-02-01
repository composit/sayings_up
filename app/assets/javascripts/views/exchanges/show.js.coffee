class Sayings.Views.Exchange extends Backbone.View
  className: 'exchange'
  template: JST["exchanges/show"]
   
  render: ->
    $( this.el ).html( @template( @model.toJSON() ) )
    return this

  addEntry: (entry) ->
    entryView = new Sayings.Views.Entries( { model: entry } )
