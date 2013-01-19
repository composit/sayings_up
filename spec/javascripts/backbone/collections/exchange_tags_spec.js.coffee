describe 'Sayings.Collections.ExchangeTags', ->
  it 'contains instances of Sayings.Model.ExchangeTag', ->
    collection = new Sayings.Collections.ExchangeTags()
    expect( collection.model ).toEqual Sayings.Models.ExchangeTag
