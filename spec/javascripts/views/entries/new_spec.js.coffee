describe 'new entry view', ->
  beforeEach ->
    @collection = { url: '/exchanges/123/entries' }
    @view = new Sayings.Views.NewEntry { collection: @collection }

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has an id of "new-entry"', ->
      expect( $( @view.el ) ).toHaveId 'new-entry'

    it 'creates a new model in the local collection', ->
      expect( @view.model.collection ).toEqual @collection

  describe 'rendering', ->
    it 'contains a "respond" link', ->
      expect( $( @view.render().el ) ).toContain 'a:contains("respond")'

  describe 'new', ->
    it 'has a form for creating a new entry', ->
      $el = $( @view.render().el )
      $el.find( '#respond-link' ).click()
      expect( $el ).toContain 'form#new-entry-form'

  describe 'save', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      beforeEach ->
        @callback = sinon.spy @view.model, 'save'
        @$el = $( @view.render().el )
        @server.respondWith 'POST', '/exchanges/123/entries', [200, { 'Content-Type': 'application/json' }, '{"id":"123"}']
        @$el.find( '#respond-link' ).click()
        @$el.find( '#content' ).val 'Good entry'
        @$el.find( 'form' ).submit()
        @server.respond()

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalledOnce()

      it 'renders the new content', ->
        expect( @$el ).toContain 'div.content:contains("Good entry")'
