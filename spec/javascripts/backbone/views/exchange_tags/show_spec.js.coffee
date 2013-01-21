describe 'exchange tag show view', ->
  beforeEach ->
    @collection = new Sayings.Collections.ExchangeTags
    @collection.url = '/taggings'
    @exchange_tag = new Sayings.Models.ExchangeTag  tag_name: 'Good tag'
    @exchange_tag.collection = @collection
    @view = new Sayings.Views.ShowExchangeTag collection: @collection, model: @exchange_tag

  describe 'initialization', ->
    it 'creates a new div element', ->
      expect( @view.el.nodeName ).toEqual 'SPAN'

    it 'has a class of "exchange-tag"', ->
      expect( @view.$el ).toHaveClass 'exchange-tag'

  describe 'rendering', ->
    it 'displays the tag name', ->
      expect( @view.render().$el ).toContain 'span.tag_name:contains("Good tag")'

    it 'does not display an add-to-tag link if there is no signed in user', ->
      Sayings.currentUserSession = null
      expect( @view.render().$el ).not.toContain 'a:contains("+")'

    describe 'if a user is logged in', ->
      beforeEach ->
        Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': '123'

      it 'displays a plus if the user has not used this tag', ->
        @exchange_tag.set 'current_user_tagging_id', null
        expect( @view.render().$el ).toContain 'a:contains("+")'
        expect( @view.render().$el ).not.toContain 'a:contains("-")'

      it 'displays a minus if the user has used this tag', ->
        @exchange_tag.set 'current_user_tagging_id', '123'
        expect( @view.render().$el ).toContain 'a:contains("-")'
        expect( @view.render().$el ).not.toContain 'a:contains("+")'

  describe 'adding and removing', ->
    beforeEach ->
      Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': '123'
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'addToTag', ->
      describe 'when the save is successful', ->
        beforeEach ->
          @addOrOwnSpy = sinon.stub @collection, 'addOrOwn'
          $el = @view.render().$el
          @server.respondWith 'POST', '/taggings', [200, { 'Content-Type': 'application/json' }, '{"_id":"123"}']
          @callback = sinon.spy @view.model, 'save'
          $el.find( '.add-tag-link' ).click()
          @server.respond()

        afterEach ->
          @callback.restore()
          @addOrOwnSpy.restore()

        it 'queries the server', ->
          expect( @callback ).toHaveBeenCalled()

        it 'adds the model to the collection', ->
          expect( @addOrOwnSpy ).toHaveBeenCalledOnce()
          expect( @addOrOwnSpy ).toHaveBeenCalledWith @view.model

    describe 'removeFromTag', ->
      describe 'when the save is successful', ->
        beforeEach ->
          @exchange_tag.set 'current_user_tagging_id', '123'
          @removeOrDisownSpy = sinon.stub @collection, 'removeOrDisown'
          $el = @view.render().$el
          @server.respondWith 'DELETE', '/taggings/123', [200, { 'Content-Type': 'application/json' }, '{"_id":"123"}']
          @callback = sinon.spy jQuery, 'ajax'
          $el.find( '.remove-tag-link' ).click()
          @server.respond()

        afterEach ->
          @callback.restore()
          @removeOrDisownSpy.restore()

        it 'queries the server', ->
          expect( @callback ).toHaveBeenCalled()

        it 'removes the model from the collection', ->
          expect( @removeOrDisownSpy ).toHaveBeenCalledOnce()
          expect( @removeOrDisownSpy ).toHaveBeenCalledWith @view.model
