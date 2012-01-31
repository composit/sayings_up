SayingsUp.Views.Exchanges ||= {}

class SayingsUp.Views.Exchanges.Show extends Backbone.View
  className: 'exchange'
  template: JST["../templates/exchanges/show"]
   
  render: ->
    $( this.el ).html( @template( @model.toJSON() ) )
    return this

  addEntry: (entry) ->
    entryView = new SayingsUp.Views.Entries( { model: entry } )
