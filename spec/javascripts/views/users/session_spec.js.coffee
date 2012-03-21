describe 'user session view', ->
  beforeEach ->
    @view = new Sayings.Views.UserSession()

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has the id of "session"', ->
      expect( $( @view.el ) ).toHaveId 'session'
