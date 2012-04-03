describe 'entry show view', ->
  beforeEach ->
    @entry = new Sayings.Models.Entry( { id: 123, content: 'Good entry' } )
    @view = new Sayings.Views.ShowEntry( { model: @entry } )

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "entry"', ->
      expect( $( @view.el ) ).toHaveClass 'entry'

  describe 'rendering', ->
    it 'displays the content', ->
      expect( $( @view.render().el ) ).toContain 'div.content:contains("Good entry")'
