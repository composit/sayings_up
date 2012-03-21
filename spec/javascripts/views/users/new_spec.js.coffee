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
        @server.respondWith( "POST", "/users", [200, { "Content-Type": "application/json" }, ""] )
        @$el = $( @view.render().el )
        @$el.find( "form" ).submit()
        @server.respond()

      it 'saves the record', ->
        expect( @callback ).toHaveBeenCalled()

      it 'shows a success message when the save is successful', ->
        expect( @$el ).toContain ".notice:contains('Thanks for signing up!')"

      it 'logs the user in', ->
        #TODO should this be handled by another view? No access to the nav div
        #expect( $( "#account" ) ).toContain "a:contains('Log out')"

    it 'shows an error message when the save is not successful', ->
      @server.respondWith( "POST", "/users", [406, { "Content-Type": "application/json" }, '{"errors":{"username":["can\'t be blank"]}}'] )
      $el = $( @view.render().el )
      $el.find( "form" ).submit()
      @server.respond()
      expect( $el ).toContain ".validation-errors .error:contains('username can\'t be blank')"
