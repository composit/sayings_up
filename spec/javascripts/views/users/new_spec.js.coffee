describe 'user new view', ->
  beforeEach ->
    @view = new Sayings.Views.NewUser()

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual( 'DIV' )

  #  it 'should have an ID of "new-view"', ->
  #    expect( $( @view.el ) ).toHaveId( 'new-view' )
