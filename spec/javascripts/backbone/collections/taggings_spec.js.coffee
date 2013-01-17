describe 'Sayings.Collections.Taggings', ->
  it 'contains instances of Sayings.Model.Tagging', ->
    collection = new Sayings.Collections.Taggings()
    expect( collection.model ).toEqual Sayings.Models.Tagging
