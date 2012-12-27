describe 'exchange show view', ->
  beforeEach ->
    Sayings.router = new Sayings.Routers.Exchanges collection: []
    @comment = new Sayings.Models.Comment _id: 9
    @entry1 = new Sayings.Models.Entry _id: 1, content: 'One', comment_data: []
    @entry2 = new Sayings.Models.Entry _id: 2, content: 'Two', comment_data: [@comment]
    @entry3 = new Sayings.Models.Entry _id: 3, content: 'Three', comment_data: []
    @exchange = new Sayings.Models.Exchange id: 4, ordered_usernames: ['user one', 'user two'], ordered_user_ids: [3,4], entry_data: [@entry1, @entry2, @entry3]
    @view = new Sayings.Views.ShowExchange model: @exchange, entryId: 2, commentId: 9

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "exchange"', ->
      expect( $( @view.el ) ).toHaveClass 'exchange'

  describe 'rendering', ->
    beforeEach ->
      @showSpy = sinon.spy Sayings.Views.ShowEntry.prototype, 'showComments'
      @entryView = new Sayings.Views.ShowEntry model: @entry2
      @entryViewStub = sinon.stub( Sayings.Views, 'ShowEntry' ).returns @entryView

    afterEach ->
      @showSpy.restore()
      @entryViewStub.restore()

    it 'creates an Entry view for each entry', ->
      @view.render()
      expect( @entryViewStub ).toHaveBeenCalledThrice()
      expect( @entryViewStub ).toHaveBeenCalledWith model: @entry1
      expect( @entryViewStub ).toHaveBeenCalledWith model: @entry2
      expect( @entryViewStub ).toHaveBeenCalledWith model: @entry3

    it 'shows the comments for an entry if indicated', ->
      @view.render()
      expect( @showSpy ).toHaveBeenCalledOnce()

    xit 'marks the first entry as "current"', ->

    it 'adds a "current" designation to a comment if indicated', ->
      @view.render()
      expect( @comment.get 'current' ).toBeTruthy()

    xit 'tags the entries with classes according to its user'

    describe 'respondability', ->
      beforeEach ->
        @newEntryView = new Backbone.View()
        @newEntryViewStub = sinon.stub( Sayings.Views, 'NewEntry' ).returns @newEntryView

      afterEach ->
        Sayings.Views.NewEntry.restore()

      it 'displays a respond link if the user has rights', ->
        Sayings.currentUser = new Sayings.Models.UserSession '_id': 4
        @view.render()
        expect( @newEntryViewStub ).toHaveBeenCalledOnce()
      
      it 'does not display a respond link if the user does not have rights', ->
        Sayings.currentUser = new Sayings.Models.UserSession '_id': 1
        @view.render()
        expect( @newEntryViewStub ).not.toHaveBeenCalled()
    
  describe 're-rendering', ->
    beforeEach ->
      @renderSpy = sinon.spy Sayings.Views.ShowExchange.prototype, 'render'
      @exchange = new Sayings.Models.Exchange entries: [], ordered_usernames: []
      @view = new Sayings.Views.ShowExchange model: @exchange

    afterEach ->
      @renderSpy.restore()

    it 'renders whenever an entry is added', ->
      @exchange.entries.add new Sayings.Models.Entry
      expect( @renderSpy ).toHaveBeenCalled()

    it 'renders whenever the model changes', ->
      @exchange.set 'something', 'else'
      expect( @renderSpy ).toHaveBeenCalled()

  describe 'leaving', ->
    xit 'removes itself from its parent\'s orderedChildren array'
    xit 'leaves'

  descibe 'when the showedComments event is triggered', ->
    xit 'it removes all exchanges to the right if it is the first exchange'
    xit 'removes the exchange to the left of it if it if it is not the first'
