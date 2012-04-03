describe 'new entry view', ->
  beforeEach ->
    @entry = new Sayings.Models.Entry()
    @view = new Sayings.Views.NewEntry { model: @entry }

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has an id of "new-entry"', ->
      expect( $( @view.el ) ).toHaveId 'new-entry'

  describe 'rendering', ->
    it 'contains a "respond" link', ->
      expect( $( @view.render().el ) ).toContain 'a:contains("respond")'

  describe 'new', ->
    it 'has a form for creating a new entry', ->
      $el = $( @view.render().el )
      $el.find( '#respond-link' ).click()
      expect( $el ).toContain 'form#new-entry-form'
