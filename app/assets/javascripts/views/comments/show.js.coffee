class Sayings.Views.ShowComment extends Backbone.View
  className: 'comment'

  initialize: ->
    _.bindAll( this, 'render' )

  render: ->
    $( @el ).html JST['comments/show'] @model
    @$( '.content' ).html @model.get 'content'
    return this
