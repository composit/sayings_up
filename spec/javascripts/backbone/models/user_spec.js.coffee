describe 'User', ->
  describe 'when instantiated', ->
    beforeEach ->
      @user = new Sayings.Models.User( {} )

    it 'exhibits attributes', ->
      @user.set( { username: 'Test user' } )
      expect( @user.get 'username' ).toEqual 'Test user'

    describe 'url', ->
      beforeEach ->
        collection = { url: '/users' }
        @user.collection = collection

      describe 'when id is set', ->
        it 'returns the collection URL and id', ->
          collection = new Sayings.Collections.Users
          @user.collection = collection
          @user.id = 999
          expect( @user.url() ).toEqual '/users/999'

      describe 'when no id is set', ->
        it 'returns the collection URL', ->
          expect( @user.url() ).toEqual '/users'

