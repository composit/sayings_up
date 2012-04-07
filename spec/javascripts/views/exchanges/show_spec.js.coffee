describe 'exchange show view', ->
  beforeEach ->
    @entry1 = new Backbone.Model { id: 1, content: "One" }
    @entry2 = new Backbone.Model { id: 2, content: "Two" }
    @entry3 = new Backbone.Model { id: 3, content: "Three" }
    @exchange = new Sayings.Models.Exchange { id: 4, ordered_user_ids: [3,4], entries: [@entry1, @entry2, @entry3] }
    @view = new Sayings.Views.ShowExchange { model: @exchange }

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "exchange"', ->
      expect( $( @view.el ) ).toHaveClass 'exchange'

  describe 'rendering', ->
    beforeEach ->
      @entryView = new Backbone.View()
      @entryViewStub = sinon.stub( Sayings.Views, "ShowEntry" ).returns @entryView

    afterEach ->
      Sayings.Views.ShowEntry.restore()

    it "creates an Entry view for each entry", ->
      @view.render()
      expect( @entryViewStub ).toHaveBeenCalledThrice()
      expect( @entryViewStub ).toHaveBeenCalledWith { model: @entry1 }
      expect( @entryViewStub ).toHaveBeenCalledWith { model: @entry2 }
      expect( @entryViewStub ).toHaveBeenCalledWith { model: @entry3 }

    describe 'respondability', ->
      beforeEach ->
        @newEntryView = new Backbone.View()
        @newEntryViewStub = sinon.stub( Sayings.Views, 'NewEntry' ).returns @newEntryView

      afterEach ->
        Sayings.Views.NewEntry.restore()

      it 'displays a respond link if the user has rights', ->
        Sayings.currentUser = new Sayings.Models.UserSession { '_id': 4 }
        @view.render()
        expect( @newEntryViewStub ).toHaveBeenCalledOnce()
      
      it 'does not display a respond link if the user does not have rights', ->
        Sayings.currentUser = new Sayings.Models.UserSession { '_id': 1 }
        @view.render()
        expect( @newEntryViewStub ).not.toHaveBeenCalled()

    it 'renders whenever an entry is added', ->
      #renderSpy = sinon.spy()
      #@view.on 'render', renderSpy
      sinon.spy( @view, 'render' )
      @view.model.entries.add( new Backbone.Model() )
      #@view.render()
      expect( @view.render ).toHaveBeenCalled()
