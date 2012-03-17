describe 'Sayings.Collections.Users', ->
  it 'contains instances of Sayings.Models.User', ->
    collection = new Sayings.Collections.Users()
    expect( collection.model ).toEqual Sayings.Models.User

  it 'is persisted at /users', ->
    collection = new Sayings.Collections.Users()
    expect( collection.url ).toEqual '/users'
