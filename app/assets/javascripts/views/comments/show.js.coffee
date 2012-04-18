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
    newExchange = new Sayings.Models.Exchange initial_values: { parent_exchange_id: @model.get( 'exchange_id' ), parent_entry_id: @model.get( 'entry_id' ), parent_comment_id: @model.get '_id' }
    newExchangeView = new Sayings.Views.NewExchange model: newExchange
    $( @el ).append newExchangeView.render().el
