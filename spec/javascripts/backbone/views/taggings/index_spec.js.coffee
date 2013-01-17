describe 'taggings index view', ->
  beforeEach ->
    @tagging1 = new Backbone.Model tag_name: 'One'
    @tagging2 = new Backbone.Model tag_name: 'Two'
    @tagging3 = new Backbone.Model tag_name: 'Three'
    @taggings = new Sayings.Collections.Taggings [@tagging1, @tagging2, @tagging3]
    @view = new Sayings.Views.TaggingsIndex collection: @taggings

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

  describe 'rendering', ->
    beforeEach ->
      @taggingViewSpy = sinon.spy Sayings.Views, 'ShowTagging'

    afterEach ->
      Sayings.Views.ShowTagging.restore()

    it 'creates a Tagging view for each tagging', ->
      @view.render()
      expect( @taggingViewSpy ).toHaveBeenCalledThrice()
      expect( @taggingViewSpy ).toHaveBeenCalledWith model: @tagging1
      expect( @taggingViewSpy ).toHaveBeenCalledWith model: @tagging2
      expect( @taggingViewSpy ).toHaveBeenCalledWith model: @tagging3

    it 'renders the Tagging view for each tagging', ->
      @$el = @view.render().$el
      expect( @$el.find( '.tagging' ).first() ).toHaveText 'One'
      expect( @$el.find( '.tagging' )[1] ).toHaveText 'Two'
      expect( @$el.find( '.tagging' ).last() ).toHaveText 'Three'

  describe 'respondability', ->
    beforeEach ->
      @newTaggingView = new Backbone.View()
      @newTaggingViewStub = sinon.stub( Sayings.Views, 'NewTagging' ).returns @newTaggingView

    afterEach ->
      Sayings.Views.NewTagging.restore()

    it 'displays a new tag link if the user is logged in', ->
      Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': '123'
      @view.render()
      expect( @newTaggingViewStub ).toHaveBeenCalledOnce()

    it 'does not display a respond link if the user is not logged in', ->
      Sayings.currentUserSession = new Sayings.Models.UserSession
      @view.render()
      expect( @newTaggingViewStub ).not.toHaveBeenCalled()

  describe 'updating taggings', ->
    beforeEach ->
      @renderSpy = sinon.spy Sayings.Views.TaggingsIndex.prototype, 'render'
      @taggingsView = new Sayings.Views.TaggingsIndex collection: @taggings

    afterEach ->
      @renderSpy.restore()

    it 'renders whenever a tagging is added', ->
      @taggingsView.collection.trigger 'add'
      expect( @renderSpy ).toHaveBeenCalledOnce()

    it 'renders when the taggings are changed', ->
      @taggingsView.collection.trigger 'change'
      expect( @renderSpy ).toHaveBeenCalledOnce()
