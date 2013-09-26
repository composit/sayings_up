#= require spec_helper

describe 'comment show view', ->
  beforeEach ->
    @comment = new Sayings.Models.Comment _id: '789', html_content: 'Good comment', entry_user_id: 4, exchange_id: '123', entry_id: '456', user_username: 'test user'
    @view = new Sayings.Views.ShowComment model: @comment

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

    it 'has a class of "comment"', ->
      expect( @view.$el ).toHaveClass 'comment'

  describe 'rendering', ->
    it 'displays the content', ->
      expect( @view.render().$el ).toContain 'p.content:contains("Good comment")'

    it 'displays the username', ->
      expect( @view.render().$el ).toContain '.comment-footer .username:contains("test user")'

    describe 'current', ->
      it 'adds a current class if current is set to true', ->
        @comment.set 'current', true
        expect( @view.render().$el ).toHaveClass 'current'

      it 'does not add a current class if current is not set to true', ->
        expect( @view.render().$el ).not.toHaveClass 'current'

    describe 'child exchange', ->
      beforeEach ->
        @showStub = sinon.stub( Sayings.Routers.Exchanges.prototype, 'showChild' ).returns true
        Sayings.router = new Sayings.Routers.Exchanges collection: []
        Sayings.router.exchangeManager = new Sayings.Views.ExchangeManager
        @otherComment = new Sayings.Models.Comment current: true
        @comment.collection = new Sayings.Collections.Comments [@comment, @otherComment]
        @comment.set 'child_exchange_data', { id: '234', entry_count: 11 }

      beforeEach ->
        @showStub.restore()

      it 'displays a link containing the number of entries in a child exchange if one exists', ->
        expect( @view.render().$el ).toContain 'a:contains("discussion(11)")'

      describe 'when the child link has been clicked', ->
        beforeEach ->
          @navigateSpy = sinon.spy Sayings.router, 'navigate'
          @view.render().$el.find( '.display-child-exchange' ).click()

        afterEach ->
          @navigateSpy.restore()

        it 'sets the url to the id of the child and parent exchanges', ->
          expect( @navigateSpy ).toHaveBeenCalledOnce()
          expect( @navigateSpy ).toHaveBeenCalledWith '#e/234/123'

        it 'sends the child and parent exchange ids to the showChild method on the router', ->
          expect( @showStub ).toHaveBeenCalledOnce()
          expect( @showStub ).toHaveBeenCalledWith '234', '123'


    describe 'respondability', ->
      beforeEach ->
        @newExchange = new Backbone.Model()
        @newExchangeStub = sinon.stub( Sayings.Models, 'Exchange' ).returns @newExchange
        @newExchangeView = new Backbone.View()
        @newExchangeViewStub = sinon.stub( Sayings.Views, 'NewExchange' ).returns @newExchangeView

      afterEach ->
        Sayings.Views.NewExchange.restore()
        Sayings.Models.Exchange.restore()

      describe 'if the comment is on one of the current user\'s entries', ->
        beforeEach ->
          Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': 4

        it 'builds a new exchange model', ->
          @view.render()
          expect( @newExchangeStub ).toHaveBeenCalledOnce()
          expect( @newExchangeStub ).toHaveBeenCalledWith initial_values: { parent_exchange_id: '123', parent_entry_id: '456', parent_comment_id: '789' }

        it 'displays a respond link if the comment is on one of the current user\'s entries', ->
          @view.render()
          expect( @newExchangeViewStub ).toHaveBeenCalledOnce()
          expect( @newExchangeViewStub ).toHaveBeenCalledWith model: @newExchange, parent_comment: @comment

        it 'does not display a respond link if the comment already has a child exchange', ->
          @comment.set 'child_exchange_data', { _id: '234', entry_count: 11 }
          @view.render()
          expect( @newExchangeViewStub ).not.toHaveBeenCalled()

      it 'does not display a respond link if the user does not have rights', ->
        Sayings.currentUserSession = new Sayings.Models.UserSession 'user_id': 1
        @view.render()
        expect( @newExchangeViewStub ).not.toHaveBeenCalled()
