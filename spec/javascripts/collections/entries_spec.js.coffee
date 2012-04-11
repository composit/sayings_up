describe 'Sayings.Collections.Entries', ->
  beforeEach ->
    @collection = new Sayings.Collections.Entries()
    #@exchange = new Sayings.Models.Exchange { '_id': '123', 'entries': @collection }

  it 'contains instances of Sayings.Models.Entry', ->
    expect( @collection.model ).toEqual Sayings.Models.Entry
