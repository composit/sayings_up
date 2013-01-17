describe 'Tagging', ->
  beforeEach ->
    @tagging = new Sayings.Models.Tagging()

  describe 'when instantiated', ->
    it 'exhibits attributes', ->
      @tagging.set { tag_name: 'sometag' }
      expect( @tagging.get 'tag_name' ).toEqual 'sometag'

    describe 'url', ->
      beforeEach ->
        collection = { url: '/taggings' }
        @tagging.collection = collection

      it 'returns the collection URL and id when id is set', ->
        @tagging.id = 999
        expect( @tagging.url() ).toEqual '/taggings/999'

      it 'returns the collection url when no id is set', ->
        expect( @tagging.url() ).toEqual '/taggings'
