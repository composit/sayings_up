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

    it 'displays a plus if the user has not used this tag', ->
      @exchange_tag.set 'owned_by_current_user', false
      expect( @view.render().$el ).toContain 'a:contains("+")'
      expect( @view.render().$el ).not.toContain 'a:contains("-")'

    it 'displays a minus if the user has used this tag', ->
      @exchange_tag.set 'owned_by_current_user', true
      expect( @view.render().$el ).toContain 'a:contains("-")'
      expect( @view.render().$el ).not.toContain 'a:contains("+")'

  xdescribe 'save', ->
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

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalled()
