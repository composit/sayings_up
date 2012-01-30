describe 'exchange routes', ->
  beforeEach ->
    @routeSpy = sinon.spy()
    try
      Backbone.history.start( { silent: true } )
    catch e

  it 'fires the index route with a blank hash', ->
    router = new SayingsUp.Routers.ExchangesRouter( { exchanges: [] } )
    router.bind( 'route:index', @routeSpy )
    router.navigate( '', true )
    expect( @routeSpy ).toHaveBeenCalledOnce()
    expect( @routeSpy ).toHaveBeenCalledWith()

  it 'fires the exchange detail route', ->
    router = new SayingsUp.Routers.ExchangesRouter( { exchanges: [{"_id":"999","content":"mildew","entries":[]}] } )
    router.bind( 'route:show', @routeSpy )
    router.navigate( '/999', true )
    expect( @routeSpy ).toHaveBeenCalledOnce()
    expect( @routeSpy ).toHaveBeenCalledWith( '999' )
