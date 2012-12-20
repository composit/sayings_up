describe 'Exchange', ->
  describe 'when instantiated', ->
    beforeEach ->
      @exchange = new Sayings.Models.Exchange { '_id': '789', 'entry_data': [{ '_id': '123' }, { '_id': '456' }] }

    it 'exhibits attributes', ->
      @exchange.set { content: 'Test Exchange' }
      expect( @exchange.get 'content' ).toEqual 'Test Exchange'

    it 'creates a collection for nested entries', ->
      expect( @exchange.entries instanceof Sayings.Collections.Entries ).toBeTruthy()
      expect( @exchange.entries.size() ).toEqual( 2 )

    it 'populates the collection with Entry models', ->
      expect( @exchange.entries.first() instanceof Sayings.Models.Entry ).toBeTruthy()
      expect( @exchange.entries.first().get( '_id' ) ).toEqual '123'
      expect( @exchange.entries.last() instanceof Sayings.Models.Entry ).toBeTruthy()
      expect( @exchange.entries.last().get( '_id' ) ).toEqual( '456' )

    describe 'url', ->
      beforeEach ->
        collection = { url: '/exchanges' }
        @exchange.collection = collection

      describe 'when id is set', ->
        beforeEach ->
          @exchange.id = 789

        it 'returns the collection URL and id', ->
          expect( @exchange.url() ).toEqual '/exchanges/789'

        it 'sets the entry collection\'s url', ->
          expect( @exchange.entries.url ).toEqual '/exchanges/789/entries'
      
      describe 'when no id is set', ->
        it 'returns the collection URL', ->
          @exchange.id = null
          expect( @exchange.url() ).toEqual '/exchanges'

    xit 'should not save when content is empty'
      #TODO
    
  it 'parses the entry data after a sync', ->
    exchange = new Sayings.Models.Exchange _id: 123
    exchange.set 'entry_data', [{ content: 'test content' }]
    expect( exchange.entries.length ).toEqual 0
    exchange.trigger 'sync'
    expect( exchange.entries.length ).toEqual 1
    expect( exchange.entries.last().get 'content' ).toEqual 'test content'
