describe 'Sayings.Collections.Exchanges', ->
  it 'contains instances of Sayings.Models.Example', ->
    collection = new Sayings.Collections.Exchanges()
    expect( collection.model ).toEqual Sayings.Models.Exchange

  it 'is persisted at /exchanges', ->
    collection = new Sayings.Collections.Exchanges()
    expect( collection.url ).toEqual '/exchanges'
