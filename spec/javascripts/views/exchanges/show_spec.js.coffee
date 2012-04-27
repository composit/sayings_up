describe 'exchange show view', ->
  beforeEach ->
    @comment = new Sayings.Models.Comment _id: 9
    @entry1 = new Sayings.Models.Entry _id: 1, content: 'One', comments: []
    @entry2 = new Sayings.Models.Entry _id: 2, content: 'Two', comments: [@comment]
    @entry3 = new Sayings.Models.Entry _id: 3, content: 'Three', comments: []
    @exchange = new Sayings.Models.Exchange id: 4, ordered_usernames: ['user one', 'user two'], ordered_user_ids: [3,4], entries: [@entry1, @entry2, @entry3]
    @view = new Sayings.Views.ShowExchange model: @exchange, entryId: 2, commentId: 9

  describe 'instantiation', ->
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

    it 'shows the usernames', ->
      expect( $( @view.render().el ) ).toContain '.first-username:contains("user one")'
      expect( $( @view.render().el ) ).toContain '.second-username:contains("user two")'

    it 'creates an Entry view for each entry', ->
      @view.render()
      expect( @entryViewStub ).toHaveBeenCalledThrice()
      expect( @entryViewStub ).toHaveBeenCalledWith model: @entry1
      expect( @entryViewStub ).toHaveBeenCalledWith model: @entry2
      expect( @entryViewStub ).toHaveBeenCalledWith model: @entry3

    it 'shows the comments for an entry if indicated', ->
      @view.render()
      expect( @showSpy ).toHaveBeenCalledOnce()

    it 'adds a "current" designation to a comment if indicated', ->
      @view.render()
      expect( @comment.get 'current' ).toBeTruthy()

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
    
    it 'shows the parent link', ->
      @exchange.set 'parent_exchange_id', '123'
      expect( $( @view.render().el ) ).toContain 'a:contains("back")'

    it 'does not show the parent link if there is no parent', ->
      expect( $( @view.render().el ) ).not.toContain 'a:contains("back")'

  describe 're-rendering', ->
    beforeEach ->
      @renderSpy = sinon.spy Sayings.Views.ShowExchange.prototype, 'render'
      @exchange = new Sayings.Models.Exchange entries: [], ordered_usernames: []
      @view = new Sayings.Views.ShowExchange model: @exchange

    afterEach ->
      @renderSpy.restore()

    it 'renders whenever an entry is added', ->
      @exchange.entries.trigger 'add'
      expect( @renderSpy ).toHaveBeenCalled()

    it 'renders whenever the model changes', ->
      @exchange.trigger 'change'
      expect( @renderSpy ).toHaveBeenCalled()

