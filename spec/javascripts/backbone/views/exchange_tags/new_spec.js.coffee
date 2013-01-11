describe 'new exchange tag view', ->
  beforeEach ->
    @collection = new Backbone.Collection
    @view = new Sayings.Views.NewExchangeTag collection: @collection

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has an id of "new-tag"', ->
      expect( @view.$el ).toHaveId 'new-tag'

  describe 'rendering', ->
    it 'contains a "new tag" link', ->
      expect( @view.render().$el ).toContain 'a:contains("new tag")'

  describe 'new', ->
    beforeEach ->
      @$el = @view.render().$el
      @$el.find( '#new-tag-link' ).click()

    it 'builds a new tag with the current collection specified', ->
      expect( @view.model.collection ).toEqual @collection

    it 'displays a form for creating a new tag', ->
      expect( @$el ).toContain 'form#new-tag-form'

  describe 'save', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      beforeEach ->
        @callback = sinon.spy @view.model, 'save'

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalledOnce()
