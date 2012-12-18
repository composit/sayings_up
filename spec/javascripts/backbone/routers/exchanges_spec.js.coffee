describe 'exchange routes', ->
  beforeEach ->
    @exchange = new Sayings.Models.Exchange '_id': '999', 'content': 'Test', 'entries': [{ '_id': '888' }]
    @exchanges = new Sayings.Collections.Exchanges collection: [@exchange]
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

    it 'creates a composite view', ->
      @exchangeManagerViewStub = sinon.stub( Sayings.Views, 'ExchangeManager' ).returns new Backbone.View()
      new Sayings.Routers.Exchanges collection: @exchanges
      expect( @exchangeManagerViewStub ).toHaveBeenCalledOnce()
      Sayings.Views.ExchangeManager.restore()

    it 'renders the composite view to the exchanges div', ->
      setFixtures $( sandbox id: 'exchanges' )
      router = new Sayings.Routers.Exchanges collection: @exchanges
      expect( $( '#exchanges' ) ).toContain 'div.exchange-container'

  describe 'index', ->
    beforeEach ->
      @exchangeIndexStub = sinon.stub( Sayings.Views, 'ExchangesIndex' ).returns new Backbone.View()

    afterEach ->
      Sayings.Views.ExchangesIndex.restore()

    it 'gets fired by an empty nav hash', ->
      @router.on 'route:index', @routeSpy
      @router.navigate '', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()

    it 'renders the index view', ->
      @router.index()
      expect( @exchangeIndexStub ).toHaveBeenCalledOnce()
      expect( @exchangeIndexStub ).toHaveBeenCalledWith collection: @router.collection

    it 'appends the index view to the page', ->
      setFixtures $( sandbox id: 'exchanges' )
      @router.index()
      expect( $( '#exchanges' ) ).toContain 'div'

  describe 'show', ->
    beforeEach ->
      @exchangeViewStub = sinon.stub( Sayings.Views, 'ShowExchange' ).returns new Support.CompositeView()
      @exchangeStub = sinon.stub( @router.collection, 'get' ).withArgs( '999' ).returns @exchange

    afterEach ->
      Sayings.Views.ShowExchange.restore()
      @router.collection.get.restore()

    it 'gets fired when the nav hash includes e/id', ->
      @router.on 'route:show', @routeSpy
      @router.navigate 'e/999', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith '999'

    it 'gets fired when the nav hash includes e/id/entryId/commentId', ->
      @router.on 'route:show', @routeSpy
      @router.navigate 'e/123/456/789', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @routeSpy ).toHaveBeenCalledWith '123', '456', '789'

    describe 'appending', ->
      it 'appends the exchange view to the exchange manager', ->
        @addChildSpy = sinon.spy @router.exchangeManager, 'addFromRight'
        @router.show '999'
        expect( @addChildSpy ).toHaveBeenCalledOnce()
        @router.exchangeManager.addFromRight.restore()

    describe 'prepending', ->
      it 'prepends the exchange view child if the back button was pressed', ->
        @prependChildSpy = sinon.spy @router.exchangeManager, 'addFromLeft'
        @router.show '999', '456', '789'
        expect( @prependChildSpy ).toHaveBeenCalledOnce()
        @router.exchangeManager.addFromLeft.restore()

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
        @parseSpy = sinon.spy @exchange, 'parseEntries'
        @server = sinon.fakeServer.create()
        @server.respondWith 'GET', '/exchanges/123', [200, { 'Content-Type': 'application/json' }, '{"_id":"123","entries":[]}']
        @router.show '123'
        @server.respond()

      afterEach ->
        @exchangeStub.restore()
        @callback.restore()
        @parseSpy.restore()
        @server.restore()

      it 'fetches the exchange', ->
        expect( @callback ).toHaveBeenCalledOnce()

      it 'parses the exchange\'s entries', ->
        expect( @parseSpy ).toHaveBeenCalledOnce()
