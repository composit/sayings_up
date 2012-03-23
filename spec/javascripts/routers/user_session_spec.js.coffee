describe 'user session routes', ->
  beforeEach ->
    @user_session = new Sayings.Models.UserSession()
    @router = new Sayings.Routers.UserSessions model: @user_session
    @routeSpy = sinon.spy()
    try
      Backbone.history.start { silent: true }
      Backbone.history.started = true
    catch e
    @router.navigate 'elsewhere'

  describe 'new', ->
    beforeEach ->
      @userSessionViewStub = sinon.stub( Sayings.Views, 'UserSession' ).returns( new Backbone.View() )

    afterEach ->
      Sayings.Views.UserSession.restore()

    it 'fires the new route', ->
      @router.on 'route:new', @routeSpy
      @router.navigate 'login', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
     
    it 'renders the new view', ->
      @router.new()
      expect( @userSessionViewStub ).toHaveBeenCalledOnce()
      #TODO how to stub the new model?
      #expect( @userSessionViewStub ).toHaveBeenCalledWith( model: @userSession )
