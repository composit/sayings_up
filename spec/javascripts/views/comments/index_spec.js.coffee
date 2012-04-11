describe 'comments index view', ->
  beforeEach ->
    @comment1 = new Backbone.Model { id: 1, content: 'One' }
    @comment2 = new Backbone.Model { id: 2, content: 'Two' }
    @comment3 = new Backbone.Model { id: 3, content: 'Three' }
    @comments = new Sayings.Collections.Comments [@comment1, @comment2, @comment3]
    @view = new Sayings.Views.CommentsIndex { collection: @comments }

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
      expect( @commentViewStub ).toHaveBeenCalledWith { model: @comment1 }
      expect( @commentViewStub ).toHaveBeenCalledWith { model: @comment2 }
      expect( @commentViewStub ).toHaveBeenCalledWith { model: @comment3 }
