describe 'ExchangeTag', ->
  beforeEach ->
    @exchange_tag = new Sayings.Models.ExchangeTag()

  describe 'when instantiated', ->
    it 'exhibits attributes', ->
      @exchange_tag.set { tag_name: 'sometag' }
      expect( @exchange_tag.get 'tag_name' ).toEqual 'sometag'

    describe 'url', ->
      beforeEach ->
        collection = { url: '/exchange_tags' }
        @exchange_tag.collection = collection

      it 'returns the collection URL and id when id is set', ->
        @exchange_tag.id = 999
        expect( @exchange_tag.url() ).toEqual '/exchange_tags/999'

      it 'returns the collection url when no id is set', ->
        expect( @exchange_tag.url() ).toEqual '/exchange_tags'
