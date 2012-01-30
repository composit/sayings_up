describe 'Exchange', ->
  describe 'when instantiated', ->
    beforeEach ->
      @exchange = new SayingsUp.Models.Exchange

    it 'exhibits attributes', ->
      @exchange.set( { content: 'Test Exchange' } )
      expect( @exchange.get 'content' ).toEqual 'Test Exchange'

    describe 'url', ->
      beforeEach ->
        collection = { url: '/exchanges' }
        @exchange.collection = collection

      describe 'when id is set', ->
        it 'returns the collection URL and id', ->
          collection = new SayingsUp.Collections.Exchanges
          @exchange.collection = collection
          @exchange.id = 999
          expect( @exchange.url() ).toEqual '/exchanges/999'

      describe 'when no id is set', ->
        it 'returns the collection URL', ->
          expect( @exchange.url() ).toEqual '/exchanges'

    xit 'should not save when content is empty'

describe 'Exchanges', ->
  describe 'url', ->
    it 'should be defined', ->
      exchanges = new SayingsUp.Collections.Exchanges
      expect( exchanges.url ).toEqual '/exchanges'
