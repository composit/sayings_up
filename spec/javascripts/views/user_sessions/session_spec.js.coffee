describe 'user session view', ->
  beforeEach ->
    @user_session = new Sayings.Models.UserSession()
    @view = new Sayings.Views.UserSession( { model: @user_session } )

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

  describe 'new', ->
    it 'has a form for signing in', ->
      $el = $( @view.render().el )
      $el.find( '#sign-in-link' ).click()
      expect( $el ).toContain( 'form#sign-in-form' )

  describe 'signing in', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the sign in is successful', ->
      beforeEach ->
        @callback = sinon.spy( @user_session, 'save' )
        @$el = $( @view.render().el )
        @server.respondWith( "POST", "/user_sessions", [200, { "Content-Type": "application/json" }, ''] )
        @$el.find( '#sign-in-link' ).click()
        @$el.find( "form" ).submit()
        @server.respond()

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalled()

      it 'renders the welcome message', ->
        #expect( 
        #TODO

    describe 'when the sign in is unsuccessful', ->
      #TODO
