#= require spec_helper

describe 'Comment', ->
  describe 'when instantiated', ->
    beforeEach ->
      @comment = new Sayings.Models.Comment { 'content': 'Good comment' }

    it 'exhibits attributes', ->
      @comment.set { content: 'Some content' }
      expect( @comment.get 'content' ).toEqual 'Some content'

    describe 'url', ->
      beforeEach ->
        collection = { url: '/comments' }
        @comment.collection = collection

      describe 'when id is set', ->
        it 'returns the collection URL and id', ->
          @comment.id = 999
          expect( @comment.url() ).toEqual '/comments/999'

      describe 'when no id is set', ->
        it 'returns the collection URL', ->
          expect( @comment.url() ).toEqual '/comments'
