describe 'Exchange', ->
  describe 'when instantiated', ->
    beforeEach ->
      @exchange = new Sayings.Models.Exchange { '_id': '789', 'entry_data': [{ '_id': '123' }, { '_id': '456' }], 'tagging_data': [{ '_id': '987' }, { '_id': '654' }] }

    it 'exhibits attributes', ->
      @exchange.set { content: 'Test Exchange' }
      expect( @exchange.get 'content' ).toEqual 'Test Exchange'

    describe 'entries', ->
      it 'creates a collection for nested entries', ->
        expect( @exchange.entries instanceof Sayings.Collections.Entries ).toBeTruthy()
        expect( @exchange.entries.size() ).toEqual( 2 )

      it 'populates the collection with Entry models', ->
        expect( @exchange.entries.first() instanceof Sayings.Models.Entry ).toBeTruthy()
        expect( @exchange.entries.first().get( '_id' ) ).toEqual '123'
        expect( @exchange.entries.last() instanceof Sayings.Models.Entry ).toBeTruthy()
        expect( @exchange.entries.last().get( '_id' ) ).toEqual( '456' )

    describe 'taggings', ->
      it 'creates a collection for nested taggings', ->
        expect( @exchange.taggings instanceof Sayings.Collections.Taggings ).toBeTruthy()
        expect( @exchange.taggings.size() ).toEqual( 2 )

      it 'populates the collection with Tagging models', ->
        expect( @exchange.taggings.first() instanceof Sayings.Models.Tagging ).toBeTruthy()
        expect( @exchange.taggings.first().get( '_id' ) ).toEqual '987'
        expect( @exchange.taggings.last() instanceof Sayings.Models.Tagging ).toBeTruthy()
        expect( @exchange.taggings.last().get( '_id' ) ).toEqual( '654' )

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
  
  it 'parses the entry data after a change', ->
    exchange = new Sayings.Models.Exchange _id: 123
    exchange.set 'entry_data', [{ content: 'test content' }]
    expect( exchange.entries.length ).toEqual 1
    expect( exchange.entries.last().get 'content' ).toEqual 'test content'
