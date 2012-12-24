getsTheViewAndTheExchangeAllSetUp = () ->
  describe 'get it', ->
    beforeEach ->
      @exchangeViewStub = sinon.stub( Sayings.Views, 'ShowExchange' ).returns new Support.CompositeView()
      @exchangeStub = sinon.stub( @router.collection, 'get' ).withArgs( '999' ).returns @exchange

    afterEach ->
      Sayings.Views.ShowExchange.restore()
      @router.collection.get.restore()

    it 'creates a composite view', ->
      @exchangeManagerViewSpy = sinon.spy Sayings.Views, 'ExchangeManager'
      @router.show '999'
      expect( @exchangeManagerViewSpy ).toHaveBeenCalledOnce()
      Sayings.Views.ExchangeManager.restore()

    it 'renders the composite view to the exchanges div', ->
      setFixtures $( sandbox id: 'exchanges' )
      @router.show '999'
      expect( $( '#exchanges' ) ).toContain 'div.exchange-container'

    it 'builds the show view', ->
      @router.show '999'
      expect( @exchangeViewStub ).toHaveBeenCalledOnce()
      expect( @exchangeViewStub ).toHaveBeenCalledWith model: @exchange, entryId: undefined, commentId: undefined

    it 'builds the show view with entry and comment ids', ->
      @router.show '999', '456', '789'
      expect( @exchangeViewStub ).toHaveBeenCalledOnce()
      expect( @exchangeViewStub ).toHaveBeenCalledWith model: @exchange, entryId: '456', commentId: '789'

    describe 'when the exchange info isn\'t already loaded', ->
      beforeEach ->
        @exchange = new Sayings.Models.Exchange _id: '123'
        @exchangeStub = sinon.stub( Sayings.Models, 'Exchange' ).returns @exchange
        @callback = sinon.spy @exchange, 'fetch'
        @server = sinon.fakeServer.create()
        @server.respondWith 'GET', '/exchanges/123', [200, { 'Content-Type': 'application/json' }, '{"_id":"123","entries":[]}']
        @router.show '123'
        @server.respond()

      afterEach ->
        @exchangeStub.restore()
        @callback.restore()
        @server.restore()

      it 'fetches the exchange', ->
        expect( @callback ).toHaveBeenCalledOnce()

      it 'adds the exchange to the router\'s collection', ->
        expect( @router.collection ).toContain @exchange

describe 'exchange routes', ->
  beforeEach ->
    @exchange = new Sayings.Models.Exchange '_id': '999', 'content': 'Test', 'entry_data': [{ '_id': '888' }]
    @exchanges = new Sayings.Collections.Exchanges [@exchange]
    @router = new Sayings.Routers.Exchanges collection: @exchanges
    @routeSpy = sinon.spy()
    try
      Backbone.history.start silent: true
      Backbone.history.started = true
    catch e
    @router.navigate 'elsewhere'

  describe 'initialize', ->
    it 'creates a collection of exchanges', ->
      router = new Sayings.Routers.Exchanges collection: @exchanges
      expect( router.collection ).toEqual @exchanges

  describe 'index', ->
    it 'gets fired by an empty nav hash', ->
      @router.on 'route:index', @routeSpy
      @router.navigate '', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()

  describe 'appending', ->
    it 'gets fired when the nav hash includes e/id', ->
      @router.on 'route:show', @routeSpy
      @router.navigate 'e/999', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith '999'

    it 'appends the exchange view to the exchange manager', ->
      @addChildSpy = sinon.spy Sayings.Views.ExchangeManager.prototype, 'addFromRight'
      @router.show '999'
      expect( @addChildSpy ).toHaveBeenCalledOnce()
      @addChildSpy.restore()

    getsTheViewAndTheExchangeAllSetUp()

  describe 'prepending', ->
    it 'gets fired when the nav hash includes e/id/entryId/commentId', ->
      @router.on 'route:show', @routeSpy
      @router.navigate 'e/999/456/789', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith '999', '456', '789'

    it 'prepends the exchange view child if the back button was pressed', ->
      @prependChildSpy = sinon.spy Sayings.Views.ExchangeManager.prototype, 'addFromLeft'
      @router.show '999', '456', '789'
      expect( @prependChildSpy ).toHaveBeenCalledOnce()
      @router.exchangeManager.addFromLeft.restore()

    getsTheViewAndTheExchangeAllSetUp()
