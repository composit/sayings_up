describe 'entry show view', ->
  beforeEach ->
    @entry = new Sayings.Models.Entry( { id: 123, content: 'Good entry' } )
    @view = new Sayings.Views.ShowEntry( { model: @entry } )

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "entry"', ->
      expect( $( @view.el ) ).toHaveClass 'entry'

  describe 'rendering', ->
    it 'displays the content', ->
      expect( $( @view.render().el ) ).toContain 'div.content:contains("Good entry")'

  describe 'commenting', ->
    beforeEach ->
      @newCommentView = new Backbone.View()
      @newCommentViewStub = sinon.stub( Sayings.Views, 'NewComment' ).returns @newCommentView

    it 'displays a comment link if the user has rights', ->
      Sayings.currentUser = new Sayings.Models.UserSession { '_id': 4 }
      @view.render()
      expect( @newCommentViewStub ).toHaveBeenCalledOnce()
    
    it 'does not display a respond link if the user does not have rights', ->
      @view.render()
      expect( @newCommentViewStub ).not.toHaveBeenCalled()

