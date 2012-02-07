class Sayings.Views.ShowExchange extends Backbone.View
  className: 'exchange'
  template: JST["exchanges/show"]
   
  render: ->
    $( this.el ).html( @template( @model.toJSON() ) )

    self = this
    console.pp( self )
    console.pp( @entries )
    @entries.each ( entry ) ->
      entryView = new Sayings.Views.ShowEntry( { model: entry } )
      self.$( "tbody" ).append( entryView.render().el )
    return this

  addEntry: (entry) ->
    entryView = new Sayings.Views.ShowEntry( { model: entry } )
