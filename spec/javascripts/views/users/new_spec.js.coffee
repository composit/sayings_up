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
      @callback = sinon.spy( @user, 'save' )

    afterEach ->
      @server.restore()

    it 'saves the record', ->
      @server.respondWith( "POST", "/users", [200, { "Content-Type": "application-json" }, ""] )
      $( @view.render().el ).find( "form" ).submit()
      @server.respond()
      expect( @callback ).toHaveBeenCalled()
      #expect( @callback.getCall(0) ).toContain( "mildew" )

    it 'shows a success message when the save is successful', ->
      #TODO
    it 'shows an error message when the save is not successful', ->
      #TODO
