describe 'Exchange', ->
  describe 'when instantiated', ->
    beforeEach ->
      @exchange = new Sayings.Models.Exchange( { 'entries': [{ '_id': '123' }, { '_id': '456' }] } )

    it 'exhibits attributes', ->
      @exchange.set( { content: 'Test Exchange' } )
      expect( @exchange.get 'content' ).toEqual 'Test Exchange'

    describe 'url', ->
      beforeEach ->
        collection = { url: '/exchanges' }
        @exchange.collection = collection

      describe 'when id is set', ->
        it 'returns the collection URL and id', ->
          collection = new Sayings.Collections.Exchanges
          @exchange.collection = collection
          @exchange.id = 999
          expect( @exchange.url() ).toEqual '/exchanges/999'

      describe 'when no id is set', ->
        it 'returns the collection URL', ->
          expect( @exchange.url() ).toEqual '/exchanges'

    it 'creates a collection for nested entries', ->
      expect( @exchange.entries instanceof Sayings.Collections.Entries ).toBeTruthy()
      expect( @exchange.entries.size() ).toEqual( 2 )
    
    it 'populates the collection with Entry models', ->
      expect( @exchange.entries.first() instanceof Sayings.Models.Entry ).toBeTruthy()
      expect( @exchange.entries.first().get( '_id' ) ).toEqual '123'
      expect( @exchange.entries.last() instanceof Sayings.Models.Entry ).toBeTruthy()
      expect( @exchange.entries.last().get( '_id' ) ).toEqual( '456' )

    xit 'should not save when content is empty'
      #TODO
