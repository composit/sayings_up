#= require spec_helper

rendersComments = () ->
  describe 'renders comments', ->
    it 'renders the comments when the comments link is clicked', ->
      expect( @commentIndexViewStub ).toHaveBeenCalled()
      expect( @commentIndexViewStub ).toHaveBeenCalledWith collection: @entry.comments

    it 'marks itself as the current entry', ->
      expect( @view.model.get 'current' ).toBeTruthy()

    it 'unmarks other current entries', ->
      otherEntry = new Sayings.Models.Entry _id: 456
      otherEntry.set 'current', true
      @entries.add otherEntry
      @view.showComments()
      expect( otherEntry.get 'current' ).toBeFalsy()

describe 'entry show view', ->
  beforeEach ->
    Sayings.router = new Sayings.Routers.Exchanges collection: []
    @entry = new Sayings.Models.Entry _id: 123, html_content: 'Good entry', comment_data: [{ '_id': '123' },{},{}], username: 'test user'
    @view = new Sayings.Views.ShowEntry model: @entry
    @entries = new Backbone.Collection
    @entries.add @entry

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "entry"', ->
      expect( @view.$el ).toHaveClass 'entry'

  describe 'rendering', ->
    it 'displays the content', ->
      expect( @view.render().$el ).toContain '.content:contains("Good entry")'

    it 'displays the username', ->
      expect( @view.render().$el ).toContain '.entry-footer .username:contains("test user")'

    describe 'current', ->
      it 'adds a current class if current is set to true', ->
        @entry.set 'current', true
        expect( @view.render().$el ).toHaveClass 'current'

      it 'does not add a current class if current is not set to true', ->
        expect( @view.render().$el ).not.toHaveClass 'current'

      it 'displays the number of comments', ->
        expect( @view.render().$el ).toContain 'a:contains("3 comments")'

  describe 'viewing comments', ->
    beforeEach ->
      @commentIndexView = new Backbone.View()
      @commentIndexViewStub = sinon.stub( Sayings.Views, 'CommentsIndex' ).returns @commentIndexView
      
    afterEach ->
      Sayings.Views.CommentsIndex.restore()

    describe 'when the "show comments" link is clicked', ->
      beforeEach ->
        @showedSpy = sinon.spy()
        @view.model.collection.on 'showedComments', @showedSpy
        @view.render().$el.find( '.show-comments' ).click()

      it 'triggers the showedComments event on the collection', ->
        expect( @showedSpy ).toHaveBeenCalledOnce()

      rendersComments()

    describe 'show comments', ->
      beforeEach ->
        @view.showComments()

      rendersComments()

  describe 're-rendering', ->
    beforeEach ->
      @renderSpy = sinon.spy Sayings.Views.ShowEntry.prototype, 'render'
      entry = new Sayings.Models.Entry
      @view = new Sayings.Views.ShowEntry model: entry

    afterEach ->
      @renderSpy.restore()

    it 're-renders if the model\'s current state changes', ->
      @view.model.set 'current', true
      expect( @renderSpy ).toHaveBeenCalledOnce()

    it 're-renders if a comment is added', ->
      @view.model.comments.add new Sayings.Models.Comment
      expect( @renderSpy ).toHaveBeenCalledOnce()
