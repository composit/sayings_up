describe 'Sayings.Collections.Users', ->
  beforeEach ->
    @collection = new Sayings.Collections.Users()

  it 'contains instances of Sayings.Models.User', ->
    expect( @collection.model ).toEqual Sayings.Models.User

  it 'is persisted at /users', ->
    expect( @collection.url ).toEqual '/users'
