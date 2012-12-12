describe 'Sayings.Collections.Exchanges', ->
  beforeEach ->
    @collection = new Sayings.Collections.Exchanges()

  it 'contains instances of Sayings.Models.Exchange', ->
    expect( @collection.model ).toEqual Sayings.Models.Exchange

  it 'is persisted at /exchanges', ->
    expect( @collection.url ).toEqual '/exchanges'
