describe 'exchange tag show view', ->
  beforeEach ->
    @exchange_tag = new Sayings.Models.ExchangeTag _id: '789', tag_name: 'Good tag'
    @view = new Sayings.Views.ShowExchangeTag model: @exchange_tag

  describe 'initialization', ->
    it 'creates a new div element', ->
      expect( @view.el.nodeName ).toEqual 'SPAN'

    it 'has a class of "exchange-tag"', ->
      expect( @view.$el ).toHaveClass 'exchange-tag'

  describe 'rendering', ->
    it 'displays the tag name', ->
      expect( @view.render().$el ).toContain 'span.tag_name:contains("Good tag")'

  describe 'save', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      beforeEach ->
        $el = @view.render().$el
        @server.respondWith 'POST', '/exchange_tags', [200, { 'Content-Type': 'application/json' }, '{"id":"123"}']
        @callback = sinon.spy @view.model, 'save'
        $el.find( '#add-exchange-tag-link' ).click()
        @server.respond()

      afterEach ->
        @callback.restore()

      xit 'queries the server', ->
        expect( @callback ).toHaveBeenCalled()
