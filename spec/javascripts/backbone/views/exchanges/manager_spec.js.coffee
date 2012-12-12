describe 'exchange manager view', ->
  beforeEach ->
    @view = new Sayings.Views.ExchangeManager

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'
