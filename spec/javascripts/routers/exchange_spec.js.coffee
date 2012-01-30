describe 'exchange routes', ->
  beforeEach ->
    @routeSpy = sinon.spy()
    try
      Backbone.history.start( { silent: true } )
    catch e

  describe 'show', ->
    beforeEach ->
      @router = new SayingsUp.Routers.Exchanges( { exchanges: [{"_id":"999","content":"Test","entries":[]}] } )
      @router.bind( 'route:show', @routeSpy )

    it 'fires the show exchange route', ->
      @router.navigate( '/999', true )
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith( '999' )

    it 'renders the show view', ->
      exchangeViewMock = sinon.mock( SayingsUp.Views.Exchanges.Show )
      exchangeViewMock.expects( "render" ).once()
      @router.navigate( '/999', true )
      exchangeViewMock.verify()
