class Sayings.Views.ShowEntry extends Backbone.View
  className: 'entry'

  initialize: ->
    #_.bindAll( this, 'render' )

  render: ->
    $( @el ).html JST['entries/show'] @model
    @$( '.content' ).html @model.get 'content'
    return this
