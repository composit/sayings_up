describe 'user routes', ->
  beforeEach ->
    @users = new Sayings.Collections.Users collection: []
    @router = new Sayings.Routers.Users collection: @users
    @routeSpy = sinon.spy()
    try
      Backbone.history.start { silent: true }
      Backbone.history.started = true
    catch e
    @router.navigate 'elsewhere'

  describe 'new', ->
    beforeEach ->
      @newUserViewStub = sinon.stub( Sayings.Views, 'NewUser' ).returns( new Backbone.View() )

    afterEach ->
      Sayings.Views.NewUser.restore()

    it 'fires the new route', ->
      @router.on 'route:new', @routeSpy
      @router.navigate 'signup', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()

    it 'renders the new view', ->
      @router.new()
      expect( @newUserViewStub ).toHaveBeenCalledOnce()
      #TODO how to stub/spy the new model?
      #expect( @newUserViewStub ).toHaveBeenCalledWith( model: @newUserStub )
