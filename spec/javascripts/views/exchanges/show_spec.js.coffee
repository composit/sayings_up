describe 'exchange show view', ->
  beforeEach ->
    @entry1 = new Backbone.Model( { id: 1, content: "One" } )
    @entry2 = new Backbone.Model( { id: 2, content: "Two" } )
    @entry3 = new Backbone.Model( { id: 3, content: "Three" } )
    @exchange = new Sayings.Models.Exchange( { id: 4, user_ids: [3,4], entries: [@entry1, @entry2, @entry3] } )
    @view = new Sayings.Views.ShowExchange( { model: @exchange } )

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual( 'DIV' )

    it 'should have a class of "exchange"', ->
      expect( $( @view.el ) ).toHaveClass( 'exchange' )

  describe 'rendering', ->
    beforeEach ->
      @entryView = new Backbone.View()
      @entryViewStub = sinon.stub( Sayings.Views, "ShowEntry" ).returns( @entryView )
      @view.render()

    afterEach ->
      Sayings.Views.ShowEntry.restore()

    it "creates an Entry view for each entry", ->
      expect( @entryViewStub ).toHaveBeenCalledThrice()
      expect( @entryViewStub ).toHaveBeenCalledWith( { model: @entry1 } )
      expect( @entryViewStub ).toHaveBeenCalledWith( { model: @entry2 } )
      expect( @entryViewStub ).toHaveBeenCalledWith( { model: @entry3 } )

    it 'displays a respond link if the user has rights', ->
      Sayings.currentUser = new Sayings.Models.UserSession( { '_id': 4 } )
      expect( $( @view.render().el ) ).toContain 'a:contains("respond")'
    
    it 'does not display a respond link if the user does not have rights', ->
      Sayings.currentUser = new Sayings.Models.UserSession( { '_id': 1 } )
      expect( $( @view.render().el ) ).not.toContain 'a:contains("respond")'
