describe 'User', ->
  describe 'when instantiated', ->
    beforeEach ->
      @user = new Sayings.Models.User( {} )

    it 'exhibits attributes', ->
      @user.set( { username: 'Test user' } )
      expect( @user.get 'username' ).toEqual 'Test user'
