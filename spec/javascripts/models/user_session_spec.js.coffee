describe 'UserSession', ->
  describe 'when instantiated', ->
    beforeEach ->
      @user_session = new Sayings.Models.UserSession( {} )

    it 'exhibits attributes', ->
      @user_session.set( { user_id: '1234' } )
      expect( @user_session.get 'user_id' ).toEqual '1234'

    describe 'url', ->
      describe 'when a user_id is set', ->
        it 'returns the collection URL and the user_id', ->
          @user_session.set( { user_id: '4321' } )
          expect( @user_session.url() ).toEqual '/user_sessions/4321'

      describe 'when a user_id is not set', ->
        it 'returns the collection URL', ->
          expect( @user_session.url() ).toEqual '/user_sessions'
