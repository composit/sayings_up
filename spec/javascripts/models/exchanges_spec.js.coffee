describe 'Exchange', ->
  describe 'when instantiated', ->
    it 'should exhibit attributes', ->
      exchange = new SayingsUp.Models.Exchange { title: 'Test Exchange' }
      expect( exchange.get( 'title' ) ).toEqual( 'Test Exchange' )
