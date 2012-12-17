describe 'entry show view', ->
  beforeEach ->
    Sayings.router = new Sayings.Routers.Exchanges collection: []
    @entry = new Sayings.Models.Entry _id: 123, content: 'Good entry', comments: [{ '_id': '123' },{},{}], username: 'test user'
    @view = new Sayings.Views.ShowEntry model: @entry
    @entries = new Backbone.Collection
    @entries.add @entry

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "entry"', ->
      expect( $( @view.el ) ).toHaveClass 'entry'

  describe 'rendering', ->
    it 'displays the content', ->
      expect( $( @view.render().el ) ).toContain '.content:contains("Good entry")'

    it 'displays the username', ->
      expect( $( @view.render().el ) ).toContain '.entry-footer .username:contains("test user")'

    describe 'current', ->
      it 'adds a current class if current is set to true', ->
        @entry.set 'current', true
        expect( $( @view.render().el ) ).toHaveClass 'current'

      it 'does not add a current class if current is not set to true', ->
        expect( $( @view.render().el ) ).not.toHaveClass 'current'

      it 'displays the number of comments', ->
        expect( $( @view.render().el ) ).toContain 'a:contains("3 comments")'

  describe 'comments', ->
    beforeEach ->
      @commentIndexView = new Backbone.View()
      @commentIndexViewStub = sinon.stub( Sayings.Views, 'CommentsIndex' ).returns @commentIndexView
      
    afterEach ->
      Sayings.Views.CommentsIndex.restore()

    it 'renders the comments when the comments link is clicked', ->
      $( @view.render().el ).find( '.show-comments' ).click()
      expect( @commentIndexViewStub ).toHaveBeenCalled()
      expect( @commentIndexViewStub ).toHaveBeenCalledWith collection: @entry.comments

    it 'marks itself as the current entry', ->
      @view.showComments()
      expect( @view.model.get 'current' ).toBeTruthy()

    it 'unmarks other current entries', ->
      otherEntry = new Sayings.Models.Entry _id: 456
      otherEntry.set 'current', true
      @entries.add otherEntry
      @view.showComments()
      expect( otherEntry.get 'current' ).toBeFalsy()

    it 'removes the previous exchange, if there is one', ->
      @view.showComments()
      #TODO use a view manager

  it 're-renders if the model\'s current state changes', ->
    renderSpy = sinon.spy Sayings.Views.ShowEntry.prototype, 'render'
    entry = new Sayings.Models.Entry
    view = new Sayings.Views.ShowEntry model: entry
    view.model.trigger 'change:current'
    expect( renderSpy ).toHaveBeenCalled()
    renderSpy.restore()

    #beforeEach ->
    #  @newCommentView = new Backbone.View()
    #  @newCommentViewStub = sinon.stub( Sayings.Views, 'NewComment' ).returns @newCommentView

    #it 'displays a comment link if the user has rights', ->
    #  Sayings.currentUser = new Sayings.Models.UserSession { '_id': 4 }
    #  @view.render()
    #  expect( @newCommentViewStub ).toHaveBeenCalledOnce()
    
    #it 'does not display a comment link if the user does not have rights', ->
    #  @view.render()
    #  expect( @newCommentViewStub ).not.toHaveBeenCalled()

