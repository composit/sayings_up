describe 'user new view', ->
  beforeEach ->
    @view = new Sayings.Views.NewUser()

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
      @callback = sinon.spy()
      @server = sinon.fakeServer.create()
      Sayings.Models.User.on( 'change', @callback )

    afterEach ->
      @server.restore()

    it 'saves the record', ->
      @server.respondWith( "POST", "/users", [200, { "Content-Type": "application-json"}, "goodness"] )
      $( @view.render().el ).find( 'input[type="submit"]' ).trigger( "click" )
      expect( @callback.getCall(0) ).toContain( "mildew" )

    it 'shows a success message when the save is successful', ->
      #TODO
    it 'shows an error message when the save is not successful', ->
      #TODO
