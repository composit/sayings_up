#= require spec_helper

getsTheViewAndTheExchangeAllSetUp = () ->
  describe 'get it', ->
    it 'creates a composite view', ->
      @exchangeManagerViewSpy = sinon.spy Sayings.Views, 'ExchangeManager'
      @router.navigate @urlHash, { trigger: true }
      expect( @exchangeManagerViewSpy ).toHaveBeenCalledOnce()
      Sayings.Views.ExchangeManager.restore()

    it 'renders the composite view to the exchanges div', ->
      setFixtures $( sandbox id: 'exchanges' )
      @router.navigate @urlHash, { trigger: true }
      expect( $( '#exchanges' ) ).toContain 'div.exchange-container'

  describe 'when the exchange info isn\'t already loaded', ->
    beforeEach ->
      @exchange = new Sayings.Models.Exchange _id: '123'
      @exchangeStub = sinon.stub( Sayings.Models, 'Exchange' ).returns @exchange
      @callback = sinon.spy @exchange, 'fetch'
      @server = sinon.fakeServer.create()
      @server.respondWith 'GET', '/exchanges/123', [200, { 'Content-Type': 'application/json' }, '{"_id":"123","entries":[]}']
      @router.navigate 'e/123', { trigger: true }
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

  describe 'show', ->
    beforeEach ->
      @exchangeViewStub = sinon.stub( Sayings.Views, 'ShowExchange' ).returns new Support.CompositeView()
      @exchangeStub = sinon.stub @router.collection, 'get'
      @exchangeStub.withArgs( '999' ).returns @exchange

    afterEach ->
      Sayings.Views.ShowExchange.restore()
      @router.collection.get.restore()

    describe 'rendering a child', ->
      beforeEach ->
        @urlHash = 'e/999/123'
        @parentExchage = sinon.stub()
        @exchangeStub.withArgs( '123' ).returns @parentExchange

      it 'gets fired when the nav hash includes e/exchangeId/parentExchangeId', ->
        @router.on 'route:showChild', @routeSpy
        @router.navigate @urlHash, { trigger: true }
        expect( @routeSpy ).toHaveBeenCalledOnce()
        expect( @routeSpy ).toHaveBeenCalledWith '999', '123'

      it 'gets fired when the nav hash includes e/exchangeId', ->
        urlHash = 'e/999'
        @router.on 'route:showChild', @routeSpy
        @router.navigate urlHash, { trigger: true }
        expect( @routeSpy ).toHaveBeenCalledOnce()
        expect( @routeSpy ).toHaveBeenCalledWith '999'

      it 'appends the exchange view to the exchange manager', ->
        @addChildSpy = sinon.spy Sayings.Views.ExchangeManager.prototype, 'addToTheRightOf'
        @router.navigate @urlHash, { trigger: true }
        expect( @addChildSpy ).toHaveBeenCalledOnce()
        expect( @addChildSpy ).toHaveBeenCalledWith @exchangeViewStub(), @parentExchange
        @addChildSpy.restore()

      it 'builds the show view', ->
        @router.navigate @urlHash, { trigger: true }
        expect( @exchangeViewStub ).toHaveBeenCalledOnce()
        expect( @exchangeViewStub ).toHaveBeenCalledWith model: @exchange, entryId: undefined, commentId: undefined

      getsTheViewAndTheExchangeAllSetUp()

    describe 'rendering a parent', ->
      beforeEach ->
        @urlHash = 'e/999/456/789'

      it 'gets fired when the nav hash includes e/id/entryId/commentId', ->
        @router.on 'route:showParent', @routeSpy
        @router.navigate @urlHash, { trigger: true }
        expect( @routeSpy ).toHaveBeenCalledOnce()
        expect( @routeSpy ).toHaveBeenCalledWith '999', '456', '789'

      it 'prepends the exchange view child if the back button was pressed', ->
        @prependChildSpy = sinon.spy Sayings.Views.ExchangeManager.prototype, 'addFromLeft'
        @router.navigate @urlHash, { trigger: true }
        expect( @prependChildSpy ).toHaveBeenCalledOnce()
        @router.exchangeManager.addFromLeft.restore()

      it 'builds the show view with entry and comment ids', ->
        @router.navigate @urlHash, { trigger: true }
        expect( @exchangeViewStub ).toHaveBeenCalledOnce()
        expect( @exchangeViewStub ).toHaveBeenCalledWith model: @exchange, entryId: '456', commentId: '789'

      getsTheViewAndTheExchangeAllSetUp()
