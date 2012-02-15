class Sayings.Routers.Exchanges extends Backbone.Router
  initialize: ( options ) ->
    @collection = options.collection

  routes:
    #'/new'      : 'newExchange'
    #'/:id/edit' : 'edit'
    '/:id'      : 'show'
    '.*'        : 'index'

  #newExchange: ->
  #  @view = new Sayings.Views.NewExchange(collection: @exchanges)
  #  $('#exchanges').html(@view.render().el)

  index: ->
    view = new Sayings.Views.ExchangesIndex( { collection: @collection } )
    $( '#exchanges' ).html( view.render().el )

  show: ( id ) ->
    exchange = @collection.get( id )
    exchange = Sayings.exchanges.get( id )
   
    @view = new Sayings.Views.ShowExchange( model: exchange )
    $( '#exchanges' ).html( @view.render().el )
    
  #edit: (id) ->
  #  exchange = @exchanges.get(id)

  #  @view = new Sayings.Views.EditExchange(model: exchange)
  #  $('#exchanges').html(@view.render().el)
