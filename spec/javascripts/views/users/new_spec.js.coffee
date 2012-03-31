describe 'user new view', ->
  beforeEach ->
    @user = new Sayings.Models.User()
    @view = new Sayings.Views.NewUser( { model: @user } )

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has an id of "user"', ->
      expect( $( @view.el ) ).toHaveId 'user'

  describe 'rendering', ->
    it 'creates a form to add a new user', ->
      expect( $( @view.render().el ) ).toContain 'form#new-user'

  describe 'saving', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'when the save is successful', ->
      beforeEach ->
        @callback = sinon.spy( @user, 'save' )
        @userSessionViewMock = sinon.mock( Sayings.Views.UserSession.prototype )
        @userSessionViewMock.expects( 'saved' ).once()
        @$el = $( @view.render().el )
        @$el.find( '#username' ).val( 'testuser' )
        @server.respondWith( "POST", "/users", [200, { "Content-Type": "application/json" }, '{"_id":"12345"}'] )
        @$el.find( "form" ).submit()
        @server.respond()

      afterEach ->
        @userSessionViewMock.restore()

      it 'saves the record', ->
        expect( @callback ).toHaveBeenCalled()

      it 'shows a success message when the save is successful', ->
        expect( @$el ).toContain ".notice:contains('Welcome, testuser')"

      describe 'when logging the user in', ->
        it 'fires the saved method on a new user session view', ->
          @userSessionViewMock.verify()
          #@userSessionViewMock.restore()

    it 'shows an error message when the save is not successful', ->
      @server.respondWith( "POST", "/users", [406, { "Content-Type": "application/json" }, '{"errors":{"username":["can\'t be blank"]}}'] )
      $el = $( @view.render().el )
      $el.find( "form" ).submit()
      @server.respond()
      expect( $el ).toContain ".validation-errors .error:contains('username can\'t be blank')"

    it 'clears the messages from the previous save attempt at each attempt', ->
      $el = $( @view.render().el )
      @server.respondWith( "POST", "/users", [406, { "Content-Type": "application/json" }, '{"errors":{"username":["can\'t be blank"]}}'] )
      $el.find( "form" ).submit()
      @server.respond()
      @server.restore()
      @server = sinon.fakeServer.create()
      expect( $el ).toContain ".validation-errors .error:contains('username can\'t be blank')"
      @server.respondWith( "POST", "/users", [200, { "Content-Type": "application/json" }, ""] )
      $el.find( '#username' ).val( 'testuser' )
      $el.find( "form" ).submit()
      @server.respond()
      expect( $el ).toContain ".notice:contains('Welcome, testuser')"
      expect( $el ).not.toContain ".validation-errors .error:contains('username can\'t be blank')"

