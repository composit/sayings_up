#= require spec_helper

describe 'Exchange', ->
  describe 'when instantiated', ->
    beforeEach ->
      @exchange = new Sayings.Models.Exchange { '_id': '789', 'entry_data': [{ '_id': '123' }, { '_id': '456' }], 'exchange_tag_data': [{ '_id': '987' }, { '_id': '654' }] }

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

    describe 'exchange_tags', ->
      it 'creates a collection for nested exchange_tags', ->
        expect( @exchange.exchangeTags instanceof Sayings.Collections.ExchangeTags ).toBeTruthy()
        expect( @exchange.exchangeTags.size() ).toEqual( 2 )

      it 'populates the collection with ExchangeTag models', ->
        expect( @exchange.exchangeTags.first() instanceof Sayings.Models.ExchangeTag ).toBeTruthy()
        expect( @exchange.exchangeTags.first().get( '_id' ) ).toEqual '987'
        expect( @exchange.exchangeTags.last() instanceof Sayings.Models.ExchangeTag ).toBeTruthy()
        expect( @exchange.exchangeTags.last().get( '_id' ) ).toEqual( '654' )

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
      
        it 'sets the exchangeTag collection\'s url', ->
          expect( @exchange.exchangeTags.url ).toEqual '/exchanges/789/taggings'
      
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

  it 'parses the exchange tag data after a change', ->
    exchange = new Sayings.Models.Exchange _id: 123
    exchange.set 'exchange_tag_data', [{ tag_name: 'testtag' }]
    expect( exchange.exchangeTags.length ).toEqual 1
    expect( exchange.exchangeTags.last().get 'tag_name' ).toEqual 'testtag'
