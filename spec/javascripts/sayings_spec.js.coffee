describe 'Sayings', ->
  it 'has a namespace for Models', ->
    expect( Sayings.Models ).toBeTruthy

  it 'has a namespace for Collections', ->
    expect( Sayings.Collections ).toBeTruthy

  it 'has a namespace for views', ->
    expect( Sayings.Views ).toBeTruthy

  it 'has a namespace for routers', ->
    expect( Sayings.Routers ).toBeTruthy

  describe 'init()', ->
    it 'accepts exchange JSON and instantiates a collection from it', ->
      exchangeJSON = [{ '_id': '12345' }, { '_id': '54321' }]
      Sayings.init exchangeJSON, true

      expect( Sayings.exchanges ).not.toEqual undefined
      expect( Sayings.exchanges.length ).toEqual 2
      expect( Sayings.exchanges.models[0].get( '_id' ) ).toEqual '12345'
      expect( Sayings.exchanges.models[1].get( '_id' ) ).toEqual '54321'

    it 'instantiates an Exchanges router', ->
      Sayings.Routers.Exchanges = sinon.spy()
      Sayings.init [], true
      expect( Sayings.Routers.Exchanges ).toHaveBeenCalled()

    it 'starts Backbone.history', ->
      Backbone.history = { start: sinon.spy() }
      Sayings.init [], true
      expect( Backbone.history.start ).toHaveBeenCalled()
