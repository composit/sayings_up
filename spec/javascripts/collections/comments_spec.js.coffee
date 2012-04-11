describe 'Sayings.Collections.Comments', ->
  beforeEach ->
    @collection = new Sayings.Collections.Comments()
    @entry = new Sayings.Models.Entry { '_id': '123', 'comments': @collection }

  it 'contains instances of Sayings.Models.Comment', ->
    expect( @collection.model ).toEqual Sayings.Models.Comment
