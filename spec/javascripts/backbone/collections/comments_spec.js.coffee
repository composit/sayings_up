#= require spec_helper

describe 'Sayings.Collections.Comments', ->
  it 'contains instances of Sayings.Models.Comment', ->
    collection = new Sayings.Collections.Comments()
    expect( collection.model ).toEqual Sayings.Models.Comment
