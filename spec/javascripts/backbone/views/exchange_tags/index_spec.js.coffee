describe 'exchange tags index view', ->
  beforeEach ->
    @exchangeTag1 = new Backbone.Model tag_name: 'One'
    @exchangeTag2 = new Backbone.Model tag_name: 'Two'
    @exchangeTag3 = new Backbone.Model tag_name: 'Three'
    @exchangeTags = new Sayings.Collections.ExchangeTags [@exchangeTag1, @exchangeTag2, @exchangeTag3]
    @view = new Sayings.Views.ExchangeTagsIndex collection: @exchangeTags

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

  describe 'rendering', ->
    beforeEach ->
      @exchangeTagViewSpy = sinon.spy Sayings.Views, 'ShowExchangeTag'

    afterEach ->
      Sayings.Views.ShowExchangeTag.restore()

    it 'creates a ExchangeTag view for each exchangeTag', ->
      @view.render()
      expect( @exchangeTagViewSpy ).toHaveBeenCalledThrice()
      expect( @exchangeTagViewSpy ).toHaveBeenCalledWith model: @exchangeTag1
      expect( @exchangeTagViewSpy ).toHaveBeenCalledWith model: @exchangeTag2
      expect( @exchangeTagViewSpy ).toHaveBeenCalledWith model: @exchangeTag3

    it 'renders the ExchangeTag view for each exchangeTag', ->
      @$el = @view.render().$el
      expect( @$el.find( '.exchange-tag' ).first() ).toContain 'span.tag_name:contains("One")'
      expect( @$el.find( '.exchange-tag' )[1] ).toContain 'span.tag_name:contains("Two")'
      expect( @$el.find( '.exchange-tag' ).last() ).toContain 'span.tag_name:contains("Three")'

  describe 'respondability', ->
    beforeEach ->
      @newExchangeTagView = new Backbone.View()
      @newExchangeTagViewStub = sinon.stub( Sayings.Views, 'NewExchangeTag' ).returns @newExchangeTagView

    afterEach ->
      Sayings.Views.NewExchangeTag.restore()

    it 'displays a new exchange tag link if the user is logged in', ->
      Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': '123'
      @view.render()
      expect( @newExchangeTagViewStub ).toHaveBeenCalledOnce()

    it 'does not display a respond link if the user is not logged in', ->
      Sayings.currentUserSession = new Sayings.Models.UserSession
      @view.render()
      expect( @newExchangeTagViewStub ).not.toHaveBeenCalled()

  describe 'updating exchange tags', ->
    beforeEach ->
      @renderSpy = sinon.spy Sayings.Views.ExchangeTagsIndex.prototype, 'render'
      @exchangeTagsView = new Sayings.Views.ExchangeTagsIndex collection: @exchangeTags

    afterEach ->
      @renderSpy.restore()

    it 'renders whenever an exchange tag is added', ->
      @exchangeTagsView.collection.trigger 'add'
      expect( @renderSpy ).toHaveBeenCalledOnce()

    it 'renders when the exchange tags are changed', ->
      @exchangeTagsView.collection.trigger 'change'
      expect( @renderSpy ).toHaveBeenCalledOnce()
