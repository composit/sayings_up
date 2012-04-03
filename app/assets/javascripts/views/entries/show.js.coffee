class Sayings.Views.ShowEntry extends Backbone.View
  className: 'entry'

  render: ->
    $view = $( @el ).html JST['entries/show'] @model
    $view.find( '.content' ).html @model.get 'content'
    return this
