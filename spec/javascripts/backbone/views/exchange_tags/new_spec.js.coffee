describe 'new exchange tag view', ->
  beforeEach ->
    @collection = new Sayings.Collections.ExchangeTags
    @collection.url = '/taggings'
    @view = new Sayings.Views.NewExchangeTag collection: @collection

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'SPAN'

    it 'has an id of "new-exchange-tag"', ->
      expect( @view.$el ).toHaveId 'new-exchange-tag'

  describe 'rendering', ->
    it 'contains a "new tag" link', ->
      expect( @view.render().$el ).toContain 'a:contains("new tag")'

  describe 'new', ->
    beforeEach ->
      @$el = @view.render().$el
      @$el.find( '#new-exchange-tag-link' ).click()

    it 'builds a new exchange tag with the current collection specified', ->
      expect( @view.model.collection ).toEqual @collection

    it 'displays a form for creating a new exchange tag', ->
      expect( @$el ).toContain 'form#new-exchange-tag-form'

  describe 'save', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      beforeEach ->
        @addOrOwnSpy = sinon.stub @collection, 'addOrOwn'
        $el = @view.render().$el
        @server.respondWith 'POST', '/taggings', [200, { 'Content-Type': 'application/json' }, '{"_id":"123"}']
        $el.find( '#new-exchange-tag-link' ).click()
        @callback = sinon.spy @view.model, 'save'
        $el.find( '#tag_name' ).val 'newtag'
        $el.find( 'form' ).submit()
        @server.respond()

      afterEach ->
        @callback.restore()
        @addOrOwnSpy.restore()

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalled()

      it 'adds the model to the collection', ->
        expect( @addOrOwnSpy ).toHaveBeenCalledOnce()
        expect( @addOrOwnSpy ).toHaveBeenCalledWith @view.model
