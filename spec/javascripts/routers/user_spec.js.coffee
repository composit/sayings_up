describe 'user routes', ->
  beforeEach ->
  describe 'new', ->
    it 'renders the new user view', ->
      @router.navigate 'signup', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()
      expect( @userNewStub ).toHaveBeenCalledOnce()
