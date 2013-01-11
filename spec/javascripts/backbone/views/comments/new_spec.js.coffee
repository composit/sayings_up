describe 'new comment view', ->
  beforeEach ->
    @collection = new Backbone.Collection()
    @collection.url = '/exchanges/123/entries/456/comments'
    @view = new Sayings.Views.NewComment { collection: @collection }

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has an class of "new-comment"', ->
      expect( @view.$el ).toHaveClass 'new-comment'

    it 'creates a new model in the local collection', ->
      expect( @view.model.collection ).toEqual @collection

  describe 'rendering', ->
    it 'contains an "add comment" link', ->
      expect( @view.render().$el ).toContain 'a:contains("add comment")'

  describe 'new', ->
    it 'has a form for creating a new entry', ->
      @$el = @view.render().$el
      @$el.find( '#new-comment-link' ).click()
      expect( @$el ).toContain 'form#new-comment-form'

  describe 'save', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      beforeEach ->
        @callback = sinon.spy @view.model, 'save'
        @addSpy = sinon.spy @collection, 'add'
        @$el = @view.render().$el
        @server.respondWith 'POST', '/exchanges/123/entries/456/comments', [200, { 'Content-Type': 'application/json' }, '{"id":"789"}']
        @$el.find( '#new-comment-link' ).click()
        @$el.find( '#content' ).val 'Good comment'
        @$el.find( 'form' ).submit()
        @server.respond()

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalledOnce()

      it 'adds the model to the collection', ->
        expect( @addSpy ).toHaveBeenCalledOnce()
        expect( @collection.models ).toContain @view.model
