describe 'user session view', ->
  beforeEach ->
    @view = new Sayings.Views.UserSession()

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has the id of "session"', ->
      expect( $( @view.el ) ).toHaveId 'session'

  describe 'rendering', ->
    it 'has a link for signing in', ->
      expect( $( @view.render().el ) ).toContain "a:contains('Sign in')"

    it 'has a link for signing up', ->
      expect( $( @view.render().el ) ).toContain "a:contains('Sign up')"

  describe 'logging in', ->
