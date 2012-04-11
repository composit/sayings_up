describe 'comment show view', ->
  beforeEach ->
    @comment = new Sayings.Models.Comment { id: 123, content: 'Good comment' }
    @view = new Sayings.Views.ShowComment { model: @comment }

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "comment"', ->
      expect( $( @view.el ) ).toHaveClass 'comment'

  describe 'rendering', ->
    it 'displays the content', ->
      expect( $( @view.render().el ) ).toContain 'div.content:contains("Good comment")'
