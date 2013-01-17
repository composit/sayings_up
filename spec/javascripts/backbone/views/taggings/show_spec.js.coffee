describe 'tagging show view', ->
  beforeEach ->
    @tagging = new Sayings.Models.Tagging _id: '789', tag_name: 'Good tag'
    @view = new Sayings.Views.ShowTagging model: @tagging

  describe 'initialization', ->
    it 'creates a new div element', ->
      expect( @view.el.nodeName ).toEqual 'SPAN'

    it 'has a class of "tagging"', ->
      expect( @view.$el ).toHaveClass 'tagging'

  describe 'rendering', ->
    it 'displays the tag name', ->
      expect( @view.render().$el ).toContain 'span.tag_name:contains("Good tag")'
