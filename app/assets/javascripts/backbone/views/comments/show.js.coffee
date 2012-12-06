class Sayings.Views.ShowComment extends Backbone.View
  className: 'comment'

  initialize: ->
    _.bindAll( this, 'render', 'addResponder', 'addChildLink' )

  render: ->
    $( @el ).html JST['backbone/templates/comments/show'] @model
    @$( '.content' ).html @model.get 'content'
    @$( '.username' ).html @model.get 'user_username'
    if @model.get 'child_exchange_data'
      @addChildLink()
    else if Sayings.currentUser and Sayings.currentUser.id == @model.get 'entry_user_id'
      @addResponder()
    $( @el ).addClass( 'current' ) if @model.get 'current'
    return this

  addResponder: ->
    newExchange = new Sayings.Models.Exchange initial_values: { parent_exchange_id: @model.get( 'exchange_id' ), parent_entry_id: @model.get( 'entry_id' ), parent_comment_id: @model.get '_id' }
    newExchangeView = new Sayings.Views.NewExchange model: newExchange, parent_comment: @model
    @$( '.comment-footer' ).append newExchangeView.render().el

  addChildLink: ->
    childExchange = @model.get 'child_exchange_data'
    @$( '.comment-footer' ).append '<a href="/#e/' + childExchange.id + '">' + childExchange.entry_count + ' entries</a>'