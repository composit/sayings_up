describe 'user new view', ->
  beforeEach ->
    @view = new Sayings.Views.NewUser()

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has an id of "user"', ->
      expect( $( @view.el ) ).toHaveId 'user'

  describe 'rendering', ->
    it 'creates a form to add a new user', ->
      expect( $( @view.el ) ).toContain '.username label:contains( "Username" )'
      expect( $( @view.el ) ).toContain '.username input[type=text]'
