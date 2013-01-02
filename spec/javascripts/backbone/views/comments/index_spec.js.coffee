describe 'comments index view', ->
  beforeEach ->
    @comment1 = new Backbone.Model id: 1, content: 'One'
    @comment2 = new Backbone.Model id: 2, content: 'Two'
    @comment3 = new Backbone.Model id: 3, content: 'Three'
    @comments = new Sayings.Collections.Comments [@comment1, @comment2, @comment3]
    @view = new Sayings.Views.CommentsIndex collection: @comments, commentId: 2

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "comments"', ->
      expect( $( @view.el ) ).toHaveClass 'comments'

  describe 'rendering', ->
    beforeEach ->
      @commentViewSpy = sinon.spy Sayings.Views, 'ShowComment'

    afterEach ->
      Sayings.Views.ShowComment.restore()

    it 'creates a Comment view for each comment', ->
      @view.render()
      expect( @commentViewSpy ).toHaveBeenCalledThrice()
      expect( @commentViewSpy ).toHaveBeenCalledWith model: @comment1
      expect( @commentViewSpy ).toHaveBeenCalledWith model: @comment2
      expect( @commentViewSpy ).toHaveBeenCalledWith model: @comment3

    it 'renders the Comment view for each comment', ->
      @$el = $( @view.render().el )
      expect( @$el.find( '.content' ).first() ).toHaveText 'One'
      expect( @$el.find( '.content' )[1] ).toHaveText 'Two'
      expect( @$el.find( '.content' ).last() ).toHaveText 'Three'

    describe 'respondability', ->
      beforeEach ->
        @newCommentView = new Backbone.View()
        @newCommentViewStub = sinon.stub( Sayings.Views, 'NewComment' ).returns @newCommentView

      afterEach ->
        Sayings.Views.NewComment.restore()

      it 'displays a comment link if the user is logged in', ->
        Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': '123'
        @view.render()
        expect( @newCommentViewStub ).toHaveBeenCalledOnce()
      
      it 'does not display a respond link if the user is not logged in', ->
        Sayings.currentUserSession = new Sayings.Models.UserSession
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
