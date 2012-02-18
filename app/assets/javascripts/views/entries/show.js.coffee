class Sayings.Views.ShowEntry extends Backbone.View
  template: JST["entries/show"]

  render: ->
    $( @el ).html( @template( model: @model ) )
    $( @el ).html( @model.get( 'content' ) )
    return this
