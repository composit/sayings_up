describe 'exchange routes', ->
  beforeEach ->
    @routeSpy = sinon.spy()
    try
      Backbone.history.start( { silent: true } )
    catch e

  describe 'show', ->
    beforeEach ->
      @exchange = {"_id":"999","content":"Test","entries":[]}
      @router = new SayingsUp.Routers.Exchanges( { exchanges: [@exchange] } )
      @router.bind( 'route:show', @routeSpy )

    it 'fires the show route', ->
      @router.navigate( '/999', true )
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith( '999' )

    it 'renders the show view', ->
      exchangeViewStub = sinon.stub( SayingsUp.Views.Exchanges, "Show" ).returns( new Backbone.View() )
      exchangeStub = sinon.stub( @router.exchanges, "get" ).withArgs( "999" ).returns( @exchange )
      @router.show( "999" )
      expect( exchangeViewStub ).toHaveBeenCalledOnce()
      expect( exchangeViewStub ).toHaveBeenCalledWith( model: @exchange )
      exchangeViewStub.restore()
      @router.exchanges.get.restore()
