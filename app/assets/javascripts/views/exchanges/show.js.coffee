class Sayings.Views.ShowExchange extends Backbone.View
  className: 'exchange'
  template: JST["exchanges/show"]
   
  render: ->
    $( @el ).html @template( @model )

    self = this
    @model.entries.each ( entry ) ->
      entryView = new Sayings.Views.ShowEntry( { model: entry } )
      self.$( "#entries" ).append( entryView.render().el )
    return this

  #addEntry: (entry) ->
  #  entryView = new Sayings.Views.ShowEntry( { model: entry } )
