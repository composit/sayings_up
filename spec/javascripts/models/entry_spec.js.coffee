describe 'Entry', ->
  describe 'when instantiated', ->
    beforeEach ->
      @entry = new Sayings.Models.Entry { 'content': 'Good entry' }

    it 'exhibits attributes', ->
      @entry.set { content: 'Some content' }
      expect( @entry.get 'content' ).toEqual 'Some content'

    describe 'url', ->
      beforeEach ->
        collection = { url: '/entries' }
        @entry.collection = collection

      describe 'when id is set', ->
        it 'returns the collection URL and id', ->
          @entry.id = 999
          expect( @entry.url() ).toEqual '/entries/999'

      describe 'when no id is set', ->
        it 'returns the collection URL', ->
          expect( @entry.url() ).toEqual '/entries'
