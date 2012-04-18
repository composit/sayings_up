describe 'new entry view', ->
  beforeEach ->
    @view = new Sayings.Views.NewExchange()

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "new-exchange"', ->
      expect( $( @view.el ) ).toHaveClass 'new-exchange'

  describe 'rendering', ->
    it 'contains a "respond" link', ->
      expect( $( @view.render().el ) ).toContain 'a:contains("respond")'

  describe 'new', ->
    it 'has a form for creating a new exchange', ->
      $el = $( @view.render().el )
      $el.find( '.respond-link' ).click()
      expect( $el ).toContain 'form#new-exchange-form'

  describe 'save', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      beforeEach ->
        @callback = sinon.spy @view.model, 'save'
        @$el = $( @view.render().el )
        @server.respondWith 'POST', '/exchanges', [200, { 'Content-Type': 'application/json' }, '{"id":"123"}']
        @$el.find( '.respond-link' ).click()
        @$el.find( '#content' ).val 'Good exchange'
        @$el.find( 'form' ).submit()
        @server.respond()

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalledOnce()
