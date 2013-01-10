class Sayings.Views.ShowComment extends Backbone.View
  className: 'comment'

  events:
    'click .display-child-exchange': 'displayChildExchange'

  initialize: ->
    _.bindAll( this, 'render', 'addResponder', 'addChildLink', 'markCurrent' )

  render: ->
    $( @el ).html JST['backbone/templates/comments/show'] @model
    @$( '.content' ).html @model.get 'html_content'
    @$( '.username' ).html @model.get 'user_username'
    if @model.get 'child_exchange_data'
      @addChildLink()
    else if Sayings.currentUserSession and Sayings.currentUserSession.get( 'user_id' ) == @model.get 'entry_user_id'
      @addResponder()
    $( @el ).addClass( 'current' ) if @model.get 'current'
    return this

  addResponder: ->
    newExchange = new Sayings.Models.Exchange initial_values: { parent_exchange_id: @model.get( 'exchange_id' ), parent_entry_id: @model.get( 'entry_id' ), parent_comment_id: @model.get '_id' }
    newExchangeView = new Sayings.Views.NewExchange model: newExchange, parent_comment: @model
    @$( '.comment-footer' ).append newExchangeView.render().el

  addChildLink: ->
    @$( '.comment-footer' ).append '<a class="display-child-exchange" href="#">discussion(' + @childExchange().entry_count + ')</a>'

  displayChildExchange: ->
    @model.collection.each @markCurrent
    childExchange = @childExchange()
    Sayings.router.navigate '#e/' + childExchange.id + '/' + @model.get 'exchange_id'
    Sayings.router.showChild childExchange.id, @model.get 'exchange_id'
    $( 'html, body' ).animate { scrollTop: 0 }, 'slow'
    return false

  childExchange: ->
    @model.get 'child_exchange_data'

  #TODO move into manager
  markCurrent: ( comment ) ->
    if comment.id == @model.id
      comment.set 'current', true
    else
      comment.set 'current', false
