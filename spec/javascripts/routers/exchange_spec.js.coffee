describe 'exchange routes', ->
  beforeEach ->
    @exchange = { '_id': '999', 'content': 'Test', 'entries': [] }
    @router = new Sayings.Routers.Exchanges { collection: [@exchange] }
    @routeSpy = sinon.spy()
    try
      Backbone.history.start { silent: true }
    catch e
    @router.navigate( 'elsewhere' )

  describe 'index', ->
    beforeEach ->
      @router.bind 'route:index', @routeSpy

    it 'fires the index route', ->
      @router.navigate( 'a', true )
      expect( @routeSpy ).toHaveBeenCalledOnce()
    
  describe 'show', ->
    beforeEach ->
      @router.bind 'route:show', @routeSpy

    it 'fires the show route', ->
      @router.navigate( '/999', true )
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith '999'

    it 'renders the show view', ->
      exchangeViewStub = sinon.stub( Sayings.Views, 'ShowExchange' ).returns( new Backbone.View() )
      exchangeStub = sinon.stub( @router.collection, 'get' ).withArgs( '999' ).returns( @exchange )
      #@router.show( '999' )
      #expect( exchangeViewStub ).toHaveBeenCalledOnce()
      #expect( exchangeViewStub ).toHaveBeenCalledWith( model: @exchange )
      #exchangeViewStub.restore()
      #@router.exchanges.get.restore()
