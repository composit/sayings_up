describe 'exchange routes', ->
  beforeEach ->
    @exchange = new Sayings.Models.Exchange( '_id': '999', 'content': 'Test', 'entries': [{ '_id': '888' }] )
    @exchanges = new Sayings.Collections.Exchanges collection: [@exchange]
    @router = new Sayings.Routers.Exchanges collection: @exchanges
    @routeSpy = sinon.spy()
    try
      Backbone.history.start { silent: true }
      Backbone.history.started = true
    catch e
    @router.navigate 'elsewhere'

  describe 'index', ->
    beforeEach ->
      @router.on 'route:index', @routeSpy

    it 'fires the index route', ->
      @router.navigate '', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
    
  describe 'show', ->
    beforeEach ->
      @exchangeViewStub = sinon.stub( Sayings.Views, 'ShowExchange' ).returns( new Backbone.View() )
      @exchangeStub = sinon.stub( @router.collection, 'get' ).withArgs( '999' ).returns( @exchange )

    afterEach ->
      Sayings.Views.ShowExchange.restore()
      @router.collection.get.restore()

    it 'fires the show route', ->
      @router.on 'route:show', @routeSpy
      @router.navigate 'e/999', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith '999'

    it 'renders the show view', ->
      @router.show( '999' )
      expect( @exchangeViewStub ).toHaveBeenCalledOnce()
      expect( @exchangeViewStub ).toHaveBeenCalledWith( model: @exchange )
