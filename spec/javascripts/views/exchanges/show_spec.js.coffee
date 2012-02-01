describe 'exchange show view', ->
  beforeEach ->
    @entry1 = new Backbone.Model( { id: 1, content: "One" } )
    @entry2 = new Backbone.Model( { id: 2, content: "Two" } )
    @entry3 = new Backbone.Model( { id: 3, content: "Three" } )
    @exchange = new Backbone.Model( { id: 4, entries: [@entry1, @entry2, @entry3] } )
    @view = new Sayings.Views.Exchanges.Show( { model: @exchange } )

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual( 'DIV' )

    it 'should have a class of "exchange"', ->
      expect( $( @view.el ) ).toHaveClass( 'exchange' )

  describe 'rendering', ->
    beforeEach ->
      @entryView = new Backbone.View()
      @entryViewStub = sinon.stub( Sayings.Views.Entries, "Show" ).returns( @entryView )
      @view.render()

    afterEach ->
      Sayings.Views.Exchanges.Show.restore()

    it "creates an Entry view for each entry", ->
      expect( @entryViewStub ).toHaveBeenCalledThrice()
      expect( @entryViewStub ).toHaveBeenCalledWith( { model: @entry1 } )
      expect( @entryViewStub ).toHaveBeenCalledWith( { model: @entry2 } )
      expect( @entryViewStub ).toHaveBeenCalledWith( { model: @entry3 } )
