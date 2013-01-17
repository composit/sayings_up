describe 'exchange show view', ->
  beforeEach ->
    Sayings.currentUserSession = new Sayings.Models.UserSession
    Sayings.router = new Sayings.Routers.Exchanges collection: []
    @comment = new Sayings.Models.Comment _id: 9
    @entry1 = new Sayings.Models.Entry _id: 1, content: 'One', comment_data: [], user_id: 3
    @entry2 = new Sayings.Models.Entry _id: 2, content: 'Two', comment_data: [@comment], user_id: 4
    @entry3 = new Sayings.Models.Entry _id: 3, content: 'Three', comment_data: [], user_id: 3
    @exchange = new Sayings.Models.Exchange id: 4, ordered_usernames: ['user one', 'user two'], ordered_user_ids: [3,4], entry_data: [@entry1, @entry2, @entry3], taggings_data: [{ tag_name: 'TagOne' }, { tag_name: 'TagTwo' }]
    @view = new Sayings.Views.ShowExchange model: @exchange, entryId: 2, commentId: 9

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "exchange"', ->
      expect( @view.$el ).toHaveClass 'exchange'

  describe 'rendering', ->
    beforeEach ->
      @showSpy = sinon.spy Sayings.Views.ShowEntry.prototype, 'showComments'
      @currentSpy = sinon.spy Sayings.Views.ShowEntry.prototype, 'markCurrent'
      @entryViewSpy = sinon.spy Sayings.Views, 'ShowEntry'
      @taggingsIndexView = new Backbone.View()
      @taggingsIndexViewStub = sinon.stub( Sayings.Views, 'TaggingsIndex' ).returns @taggingsIndexView

    afterEach ->
      @showSpy.restore()
      @currentSpy.restore()
      @entryViewSpy.restore()
      @taggingsIndexViewStub.restore()

    describe 'entries', ->
      it 'creates an Entry view for each entry', ->
        @view.render()
        expect( @entryViewSpy ).toHaveBeenCalledThrice()
        expect( @entryViewSpy ).toHaveBeenCalledWith model: @entry1
        expect( @entryViewSpy ).toHaveBeenCalledWith model: @entry2
        expect( @entryViewSpy ).toHaveBeenCalledWith model: @entry3

      it 'shows the comments for an entry if indicated', ->
        @view.render()
        expect( @showSpy ).toHaveBeenCalledOnce()

      #TODO move into manager
      it 'marks the first entry as "current"', ->
        @view.render()
        expect( @currentSpy ).toHaveBeenCalled()

      it 'adds a "current" designation to a comment if indicated', ->
        @view.render()
        expect( @comment.get 'current' ).toBeTruthy()

      it 'assigns classes to the entries according to its user', ->
        $entries = @view.render().$el.find '.entry'
        expect( @view.render().$el.find( '.entry:even' ) ).toHaveClass 'first-user'
        expect( @view.render().$el.find( '.entry:even' ) ).not.toHaveClass 'second-user'
        expect( @view.render().$el.find( '.entry:odd' ) ).toHaveClass 'second-user'
        expect( @view.render().$el.find( '.entry:odd' ) ).not.toHaveClass 'first-user'

    describe 'taggings', ->
      it 'renders a taggings index with its taggings', ->
        @view.render()
        expect( @taggingsIndexViewStub ).toHaveBeenCalledOnce()
        expect( @taggingsIndexViewStub ).toHaveBeenCalledWith collection: @exchange.taggings

    describe 'respondability', ->
      beforeEach ->
        @newEntryView = new Backbone.View()
        @newEntryViewStub = sinon.stub( Sayings.Views, 'NewEntry' ).returns @newEntryView

      afterEach ->
        Sayings.Views.NewEntry.restore()

      it 'displays a respond link if the user has rights', ->
        Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': 4
        @view.render()
        expect( @newEntryViewStub ).toHaveBeenCalledOnce()
      
      it 'does not display a respond link if the user does not have rights', ->
        Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': 1
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

    it 'renders whenever the model syncs', ->
      @exchange.trigger 'sync'
      expect( @renderSpy ).toHaveBeenCalled()

    it 'renders whenever the login state changes', ->
      Sayings.currentUserSession.trigger 'loginStateChanged'
      expect( @renderSpy ).toHaveBeenCalled()

    it 'renders whenever the current user session is destroyed', ->
      Sayings.currentUserSession.destroy()
      expect( @renderSpy ).toHaveBeenCalled()

  #TODO use a mock to isolate this test
  it 'isolates itself when the showedComments event is triggered', ->
    jQuery.fx.off = true
    isolateSpy = sinon.spy Sayings.Views.ExchangeManager.prototype, 'isolate'
    manager = new Sayings.Views.ExchangeManager
    manager.addFromLeft @view
    @entry1.trigger 'showedComments'
    expect( isolateSpy ).toHaveBeenCalledOnce()
    isolateSpy.restore()
