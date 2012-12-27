describe 'user session view', ->
  beforeEach ->
    @user_session = new Sayings.Models.UserSession()
    @view = new Sayings.Views.UserSession( { model: @user_session } )

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has the id of "session"', ->
      expect( $( @view.el ) ).toHaveId 'session'

  describe 'rendering', ->
    describe 'with no logged in user', ->
      it 'has a link for signing in', ->
        expect( $( @view.render().el ) ).toContain "a:contains('Sign in')"

      it 'has a link for signing up', ->
        expect( $( @view.render().el ) ).toContain "a:contains('Sign up')"

    describe 'with a logged in user', ->
      beforeEach ->
        @signed_in_user_session = new Sayings.Models.UserSession( { '_id': '123', 'username': 'testuser' } )
        @signed_in_view = new Sayings.Views.UserSession( { model: @signed_in_user_session } )
        @$el = $( @signed_in_view.render().el )

      it 'displays the welcome message', ->
        expect( @$el ).toContain 'div:contains("Welcome, testuser")'

      it 'does not display the sign in link', ->
        expect( @$el ).not.toContain 'a:contains("Sign in")'

      it 'does not display the sign up link', ->
        expect( @$el ).not.toContain 'a:contains("Sign up")'

  describe 'new', ->
    it 'has a form for signing in', ->
      $el = $( @view.render().el )
      $el.find( '#sign-in-link' ).click()
      expect( $el ).toContain 'form#sign-in-form'

  describe 'signing in', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the sign in is successful', ->
      beforeEach ->
        Sayings.exchange = new Backbone.Model
        sinon.spy Sayings.exchange, 'trigger'
        @callback = sinon.spy @user_session, 'save'
        @$el = $( @view.render().el )
        @server.respondWith 'POST', '/user_sessions', [200, { 'Content-Type': 'application/json' }, '{"id":"123"}']
        @$el.find( '#sign-in-link' ).click()
        @$el.find( '#username' ).val 'testuser'
        @$el.find( 'form' ).submit()
        @server.respond()

      afterEach ->

      it 'queries the server', ->
        expect( @callback ).toHaveBeenCalledOnce()

      it 'renders the welcome message', ->
        expect( @$el ).toContain ".notice:contains('Welcome, testuser')"

      it 'removes the sign in form', ->
        expect( @$el ).not.toContain "form#sign-in-form"

      it 'logs the user in', ->
        expect( $( @$el ) ).toContain "a:contains('Sign out')"

      it 'sets the global current user', ->
        expect( Sayings.currentUser.get 'id' ).toEqual '123'

      it 'triggers a change on the current exchange', ->
        expect( Sayings.exchange.trigger ).toHaveBeenCalledOnce()
        expect( Sayings.exchange.trigger ).toHaveBeenCalled 'change'

    it 'shows an error message when the signin is not successful', ->
      $el = $( @view.render().el )
      @server.respondWith "POST", "/user_sessions", [406, { "Content-Type": "application/json" }, '{"errors":{"username":["can\'t be blank"]}}']
      $el.find( '#sign-in-link' ).click()
      $el.find( "form" ).submit()
      @server.respond()
      expect( $el ).toContain ".validation-errors .error:contains('username can\'t be blank')"

    it 'clears the messages from the previous save attempt at each attempt', ->
      $el = $( @view.render().el )
      @server.respondWith "POST", "/user_sessions", [406, { "Content-Type": "application/json" }, '{"errors":{"username":["can\'t be blank"]}}']
      $el.find( '#sign-in-link' ).click()
      $el.find( "form" ).submit()
      @server.respond()
      expect( $el ).toContain ".validation-errors .error:contains('username can\'t be blank')"
      @server.restore()
      @server = sinon.fakeServer.create()
      @server.respondWith "POST", "/user_sessions", [200, { "Content-Type": "application/json" }, ""]
      $el.find( '#sign-in-link' ).click()
      $el.find( '#username' ).val 'testuser'
      $el.find( "form" ).submit()
      @server.respond()
      expect( $el ).toContain ".notice:contains('Welcome, testuser')"
      expect( $el ).not.toContain ".validation-errors .error:contains('username can\'t be blank')"

  describe 'signing out', ->
    beforeEach ->
      server = sinon.fakeServer.create()
      @$el = $( @view.render().el )
      server.respondWith "POST", "/user_sessions", [200, { "Content-Type": "application/json" }, '{"_id":123}']
      @$el.find( '#sign-in-link' ).click()
      @$el.find( '#username' ).val 'testuser'
      @$el.find( "form" ).submit()
      server.respond()
      server.restore()
      @server = sinon.fakeServer.create()
      @server.respondWith "DELETE", "/user_sessions/123", [200, { "Content-Type": "application/json" }, '']
      Sayings.exchange = new Backbone.Model
      sinon.spy Sayings.exchange, 'trigger'
      @$el.find( '#sign-out-link' ).click()
      @server.respond()

    afterEach ->
      @server.restore()

    it 'displays the sign out message', ->
      expect( @$el ).toContain 'div:contains("You are signed out")'

    it 'allows the user to sign up or sign in again', ->
      expect( @$el ).toContain "a:contains('Sign in')"
      expect( @$el ).toContain "a:contains('Sign up')"

    it 'removes the current user id', ->
      expect( typeof Sayings.currentUser.id ).toEqual 'undefined'

    it 'triggers a change on the current exchange', ->
      expect( Sayings.exchange.trigger ).toHaveBeenCalledOnce
      expect( Sayings.exchange.trigger ).toHaveBeenCalledWith 'change'
