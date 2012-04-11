describe 'Entry', ->
  describe 'when instantiated', ->
    beforeEach ->
      @entry = new Sayings.Models.Entry { 'content': 'Good entry', 'comments': [{ '_id': '123' }, { '_id': '456' }] }

    it 'exhibits attributes', ->
      @entry.set { content: 'Some content' }
      expect( @entry.get 'content' ).toEqual 'Some content'

    it 'creates a collection for nested comments', ->
      expect( @entry.comments instanceof Sayings.Collections.Comments ).toBeTruthy()
      expect( @entry.comments.size() ).toEqual( 2 )
    
    it 'populates the collection with Entry models', ->
      expect( @entry.comments.first() instanceof Sayings.Models.Comment ).toBeTruthy()
      expect( @entry.comments.first().get( '_id' ) ).toEqual '123'
      expect( @entry.comments.last() instanceof Sayings.Models.Comment ).toBeTruthy()
      expect( @entry.comments.last().get( '_id' ) ).toEqual( '456' )


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
