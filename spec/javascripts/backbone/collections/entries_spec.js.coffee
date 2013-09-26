#= require spec_helper

describe 'Sayings.Collections.Entries', ->
  it 'contains instances of Sayings.Models.Entry', ->
    collection = new Sayings.Collections.Entries()
    expect( collection.model ).toEqual Sayings.Models.Entry
