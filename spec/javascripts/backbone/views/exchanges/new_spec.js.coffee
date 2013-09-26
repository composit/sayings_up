#= require spec_helper

describe 'new entry view', ->
  beforeEach ->
    @model = new Sayings.Models.Exchange parent_exchange_id: '123', parent_entry_id: '456', parent_comment_id: '789'
    @parent_comment = new Backbone.Model()
    @view = new Sayings.Views.NewExchange model: @model, parent_comment: @parent_comment

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "new-exchange"', ->
      expect( @view.$el ).toHaveClass 'new-exchange'

    it 'creates a model with a url', ->
      expect( @view.model.url ).toEqual '/exchanges'

  describe 'rendering', ->
    it 'contains a "respond" button', ->
      expect( @view.render().$el ).toContain 'a:contains("respond")'

  describe 'new', ->
    beforeEach ->
      @$el = @view.render().$el
      @$el.find( '.respond-link' ).click()

    it 'has a form for creating a new exchange', ->
      expect( @$el ).toContain 'form#new-exchange-form'

  describe 'save', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      #TODO test values sent in all forms
      beforeEach ->
        @callback = sinon.spy @model, 'save'
        @syncSpy = sinon.spy()
        @model.on 'sync', @syncSpy
        #TODO refactor
        Sayings.router = new Sayings.Routers.Exchanges collection: new Sayings.Collections.Exchanges []
        @addSpy = sinon.spy Sayings.router.collection, 'add'
        $el = @view.render().$el
        @server.respondWith 'POST', '/exchanges', [200, { 'Content-Type': 'application/json' }, '{"_id":"234","entry_data":[{},{}]}']
        $el.find( '.respond-link' ).click()
        $el.find( '#content' ).val 'Good exchange'
        $el.find( 'form' ).submit()
        @server.respond()

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalledOnce()

      it 'triggers the sync event on the model', ->
        expect( @syncSpy ).toHaveBeenCalledOnce()

      it 'sets the child exchange data on the parent comment', ->
        expect( @parent_comment.get 'child_exchange_data' ).toEqual( { id: '234', entry_count: 2 } )

      it 'adds the exchange to the router\'s collection', ->
        expect( @addSpy ).toHaveBeenCalledOnce()
        expect( @addSpy ).toHaveBeenCalledWith @model
