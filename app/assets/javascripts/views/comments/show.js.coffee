class Sayings.Views.ShowComment extends Backbone.View
  className: 'comment'

  initialize: ->
    _.bindAll( this, 'render', 'addResponder' )

  render: ->
    $( @el ).html JST['comments/show'] @model
    @$( '.content' ).html @model.get 'content'
    @addResponder() if Sayings.currentUser and Sayings.currentUser.id == @model.get 'entry_user_id'
    return this

  addResponder: ->
    newExchangeView = new Sayings.Views.NewExchange()
    $( @el ).append newExchangeView.render().el
