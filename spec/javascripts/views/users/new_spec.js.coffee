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
      expect( $( @view.el ) ).toContain '.user_name label:contains( "Username" )'
      expect( $( @view.el ) ).toContain '.user_name input[type=text]'
