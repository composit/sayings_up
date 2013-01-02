describe 'Sayings', ->
  it 'has a namespace for Models', ->
    expect( Sayings.Models ).toBeTruthy

  it 'has a namespace for Collections', ->
    expect( Sayings.Collections ).toBeTruthy

  it 'has a namespace for views', ->
    expect( Sayings.Views ).toBeTruthy

  it 'has a namespace for routers', ->
    expect( Sayings.Routers ).toBeTruthy

  describe 'init()', ->
    it 'accepts exchange JSON and instantiates a collection from it', ->
      exchangeJSON = [{ '_id': '12345' }, { '_id': '54321' }]
      Sayings.init exchangeJSON, {}, true

      expect( Sayings.router.collection ).not.toEqual undefined
      expect( Sayings.router.collection.length ).toEqual 2
      expect( Sayings.router.collection.models[0].get( '_id' ) ).toEqual '12345'
      expect( Sayings.router.collection.models[1].get( '_id' ) ).toEqual '54321'

    it 'accepts current user session JSON and instantiates a model from it', ->
      userJSON = { 'user_id': '123' }
      Sayings.init [], userJSON, true

      expect( Sayings.currentUserSession ).not.toEqual undefined
      expect( Sayings.currentUserSession.get( 'user_id' ) ).toEqual '123'

    it 'instantiates a new current user session if none is logged in', ->
      sinon.spy Sayings.Models, "UserSession"
      Sayings.init [], {}, true

      expect( Sayings.currentUserSession ).not.toEqual undefined
      expect( Sayings.Models.UserSession ).toHaveBeenCalled()
      Sayings.Models.UserSession.restore()

    it 'instantiates an Exchanges router', ->
      sinon.spy Sayings.Routers, "Exchanges"
      Sayings.init [], {}, true
      expect( Sayings.Routers.Exchanges ).toHaveBeenCalled()
      expect( Sayings.router ).not.toEqual undefined
      Sayings.Routers.Exchanges.restore()

    it 'instantiates a Users router', ->
      sinon.spy Sayings.Routers, "Users"
      Sayings.init [], {}, true
      expect( Sayings.Routers.Users ).toHaveBeenCalled()
      Sayings.Routers.Users.restore()

    it 'instantiates a User sessions router', ->
      sinon.spy Sayings.Routers, "UserSessions"
      Sayings.init [], {}, true
      expect( Sayings.Routers.UserSessions ).toHaveBeenCalled()
      Sayings.Routers.UserSessions.restore()

    it 'starts Backbone.history', ->
      Backbone.history.stop()
      Backbone.history.started = false
      sinon.spy Backbone.history, "start"
      Sayings.init [], {}, true
      expect( Backbone.history.start ).toHaveBeenCalled()
      Backbone.history.start.restore()
