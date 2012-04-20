describe 'comments index view', ->
  beforeEach ->
    @comment1 = new Backbone.Model id: 1, content: 'One'
    @comment2 = new Backbone.Model id: 2, content: 'Two'
    @comment3 = new Backbone.Model id: 3, content: 'Three'
    @comments = new Sayings.Collections.Comments [@comment1, @comment2, @comment3]
    @view = new Sayings.Views.CommentsIndex collection: @comments

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "comments"', ->
      expect( $( @view.el ) ).toHaveClass 'comments'

  describe 'rendering', ->
    beforeEach ->
      @commentView = new Backbone.View()
      @commentViewStub = sinon.stub( Sayings.Views, 'ShowComment' ).returns @commentView

    afterEach ->
      Sayings.Views.ShowComment.restore()

    it 'creates a Comment view for each comment', ->
      @view.render()
      expect( @commentViewStub ).toHaveBeenCalledThrice()
      expect( @commentViewStub ).toHaveBeenCalledWith model: @comment1
      expect( @commentViewStub ).toHaveBeenCalledWith model: @comment2
      expect( @commentViewStub ).toHaveBeenCalledWith model: @comment3

    describe 'respondability', ->
      beforeEach ->
        @newCommentView = new Backbone.View()
        @newCommentViewStub = sinon.stub( Sayings.Views, 'NewComment' ).returns @newCommentView

      afterEach ->
        Sayings.Views.NewComment.restore()

      it 'displays a comment link if the user is logged in', ->
        Sayings.currentUser = new Sayings.Models.UserSession '_id': 4
        @view.render()
        expect( @newCommentViewStub ).toHaveBeenCalledOnce()
      
      it 'does not display a respond link if the user is not logged in', ->
        Sayings.currentUser = new Sayings.Models.UserSession
        @view.render()
        expect( @newCommentViewStub ).not.toHaveBeenCalled()

  describe 'updating comments', ->
    beforeEach ->
      @renderSpy = sinon.spy Sayings.Views.CommentsIndex.prototype, 'render'
      @commentsView = new Sayings.Views.CommentsIndex collection: @comments

    afterEach ->
      @renderSpy.restore()

    it 'renders whenever a comment is added', ->
      @commentsView.collection.trigger 'add'
      expect( @renderSpy ).toHaveBeenCalledOnce()

    it 'renders when the comments are changed', ->
      @commentsView.collection.trigger 'change'
      expect( @renderSpy ).toHaveBeenCalledOnce()
