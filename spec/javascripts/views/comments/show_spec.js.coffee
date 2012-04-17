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

    describe 'respondability', ->
      beforeEach ->
        @newExchangeView = new Backbone.View()
        @newExchangeViewStub = sinon.stub( Sayings.Views, 'NewExchange' ).returns @newExchangeView

      afterEach ->
        Sayings.Views.NewExchange.restore()

      it 'displays a respond link if the user has rights', ->
        Sayings.currentUser = new Sayings.Models.UserSession { '_id': 4 }
        @view.render()
        expect( @newExchangeViewStub ).toHaveBeenCalledOnce()

      it 'does not display a respond link if the user does not have rights', ->
        Sayings.currentUser = new Sayings.Models.UserSession { '_id': 1 }
        @view.render()
        expect( @newExchangeViewStub ).not.toHaveBeenCalled()
