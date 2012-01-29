describe 'exchange routes', ->

  it 'fires the index route with a blank hash', ->
    exchange = new SayingsUp.Models.Exchange
    router = new SayingsUp.Routers.ExchangesRouter( { exchanges: [] } )
    routeSpy = sinon.spy()
    try
      Backbone.history.start( { silent: true } )
    catch e
    router.navigate( 'elsewhere' )
    router.bind( 'route:index', routeSpy )
    router.navigate( '', true )
    expect( routeSpy ).toHaveBeenCalledOnce()
    expect( routeSpy ).toHaveBeenCalledWith()
