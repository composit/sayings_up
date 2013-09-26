#= require spec_helper

describe 'exchange manager view', ->
  beforeEach ->
    exchanges = new Sayings.Collections.Exchanges []
    Sayings.router = new Sayings.Routers.Exchanges collection: exchanges
    @view = new Sayings.Views.ExchangeManager

  describe 'initialization', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

  describe 'going back', ->
    describe 'if there is an exchange view in the manager', ->
      beforeEach ->
        exchange = new Sayings.Models.Exchange parent_exchange_id: 123, parent_entry_id: 456, parent_comment_id: 789
        exchangeView = new Sayings.Views.ShowExchange model: exchange
        @view.orderedChildren.unshift exchangeView
        @showParentStub = sinon.stub Sayings.router, 'showParent'

      afterEach ->
        Sayings.router.showParent.restore()

      it 'changes the browser url to the parent exchange/entry/comment ids', ->
        navigateSpy = sinon.spy Sayings.router, 'navigate'
        $( @view.render().el ).find( '#back-link' ).click()
        expect( navigateSpy ).toHaveBeenCalledWith '#e/123/456/789'
        Sayings.router.navigate.restore()

      it 'fires the router showParent method', ->
        $( @view.render().el ).find( '#back-link' ).click()
        expect( @showParentStub ).toHaveBeenCalledWith 123, 456, 789

    describe 'if there is not an exchange view in the manager', ->
      it 'does not change the browser url', ->
        navigateSpy = sinon.spy Sayings.router, 'navigate'
        $( @view.render().el ).find( '#back-link' ).click()
        expect( navigateSpy ).not.toHaveBeenCalled()
        Sayings.router.navigate.restore()

      it 'does not fire the router showParent method', ->
        showParentSpy = sinon.spy Sayings.router, 'showParent'
        $( @view.render().el ).find( '#back-link' ).click()
        expect( showParentSpy ).not.toHaveBeenCalled()
        Sayings.router.showParent.restore()

  describe 'adding and removing exchange views', ->
    beforeEach ->
      jQuery.fx.off = true
      # make an entry so as to differentiate the view from others
      entry = new Sayings.Models.Entry content: 'test'
      exchange = new Sayings.Models.Exchange
      exchange.set 'entries', [entry]
      @exchangeView = new Sayings.Views.ShowExchange model: exchange
      @otherExchangeView = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
      @view.addFromLeft @otherExchangeView

    it 'removes exchanges to the right of an exchange', ->
      @view.addFromLeft @exchangeView
      @view.removeRightOfExchange @exchangeView.model
      expect( @view.orderedChildren ).toEqual _( [@exchangeView] )

    describe 'isolate', ->
      beforeEach ->
        @view.addFromLeft @exchangeView

      it 'isolates an exchange in the first position', ->
        @view.isolate @exchangeView
        expect( @view.orderedChildren ).toEqual _( [@exchangeView] )

      it 'isolates an exchange in the second position', ->
        @view.isolate @otherExchangeView
        expect( @view.orderedChildren ).toEqual _( [@otherExchangeView] )

    describe 'adding from the left', ->
      it 'prepends the view to the exchange-children div', ->
        $el = $( @view.render().el )
        @view.addFromLeft @exchangeView
        expect( $el.find( '.exchange' ).first().html() ).toEqual $( @exchangeView.render().el ).html()

      it 'adds the view to the beginning of the ordered children array', ->
        @view.addFromLeft @exchangeView
        expect( @view.orderedChildren.first() ).toEqual @exchangeView

      it 'removes the last view from the ordered children array if there are more than two', ->
        @view.render()
        exchangeViewTwo = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        exchangeViewThree = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        @view.addFromLeft exchangeViewTwo
        @view.addFromLeft exchangeViewThree
        @view.addFromLeft @exchangeView
        expect( @view.children ).not.toContain exchangeViewTwo
        expect( @view.orderedChildren ).not.toContain exchangeViewTwo

    describe 'adding to the right', ->
      it 'appends the view to the exchange-children div', ->
        $el = $( @view.render().el )
        @view.addToTheRightOf @exchangeView
        expect( $el.find( '.exchange' ).last().html() ).toEqual $( @exchangeView.render().el ).html()

      it 'adds the view to the end of the ordered children array', ->
        @view.addToTheRightOf @exchangeView
        expect( @view.orderedChildren.last() ).toEqual @exchangeView

      it 'adds the view in the right position', ->
        @view.render()
        exchangeTwo = new Sayings.Models.Exchange
        exchangeViewTwo = new Sayings.Views.ShowExchange model: exchangeTwo
        exchangeViewThree = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        @view.addToTheRightOf exchangeViewTwo
        @view.addToTheRightOf exchangeViewThree
        @view.addToTheRightOf @exchangeView, exchangeTwo
        expect( @view.orderedChildren ).toEqual _( [exchangeViewTwo, @exchangeView] )

      it 'removes views from the beginning of the ordered children array if there are more than two', ->
        @view.render()
        exchangeViewTwo = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        exchangeViewThree = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        exchangeViewFour = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        @view.addToTheRightOf exchangeViewTwo
        @view.addToTheRightOf exchangeViewThree
        @view.addToTheRightOf exchangeViewFour
        @view.addToTheRightOf @exchangeView
        expect( @view.orderedChildren.size() ).toEqual 2
        expect( @view.orderedChildren ).toEqual _( [exchangeViewFour, @exchangeView] )
