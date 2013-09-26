#= require spec_helper

describe 'Entry', ->
  describe 'when instantiated', ->
    beforeEach ->
      @entry = new Sayings.Models.Entry { '_id': '999', 'content': 'Good entry', 'exchange_id': '789', 'comment_data': [{ '_id': '123' }, { '_id': '456' }] }

    it 'exhibits attributes', ->
      @entry.set { content: 'Some content' }
      expect( @entry.get 'content' ).toEqual 'Some content'

    it 'creates a collection for nested comments', ->
      expect( @entry.comments instanceof Sayings.Collections.Comments ).toBeTruthy()
      expect( @entry.comments.size() ).toEqual( 2 )

    it 'sets the url on the comments collection', ->
      expect( @entry.comments.url ).toEqual '/exchanges/789/entries/999/comments'
    
    it 'populates the collection with Comment models', ->
      expect( @entry.comments.first() instanceof Sayings.Models.Comment ).toBeTruthy()
      expect( @entry.comments.first().get( '_id' ) ).toEqual '123'
      expect( @entry.comments.last() instanceof Sayings.Models.Comment ).toBeTruthy()
      expect( @entry.comments.last().get( '_id' ) ).toEqual( '456' )


    describe 'url', ->
      beforeEach ->
        collection = { url: '/entries', '_id': '123' }
        @entry.collection = collection

      describe 'when id is set', ->
        beforeEach ->
          @entry.id = 999

        it 'returns the collection URL and id', ->
          expect( @entry.url() ).toEqual '/entries/999'

        it 'sets the comment collection\'s url', ->
          expect( @entry.comments.url ).toEqual '/exchanges/789/entries/999/comments'

      describe 'when no id is set', ->
        it 'returns the collection URL', ->
          @entry.id = null
          expect( @entry.url() ).toEqual '/entries'

    it 'parses the comment data after a sync', ->
      entry = new Sayings.Models.Entry _id: 123
      entry.set 'comment_data', [{ content: 'test content' }]
      expect( entry.comments.length ).toEqual 0
      entry.trigger 'sync'
      expect( entry.comments.length ).toEqual 1
      expect( entry.comments.last().get 'content' ).toEqual 'test content'
