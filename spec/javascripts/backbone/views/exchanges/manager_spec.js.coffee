describe 'exchange manager view', ->
  beforeEach ->
    exchanges = new Sayings.Collections.Exchanges []
    Sayings.router = new Sayings.Routers.Exchanges collection: exchanges
    @view = new Sayings.Views.ExchangeManager

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

  describe 'going back', ->
    describe 'if there is an exchange view in the manager', ->
      beforeEach ->
        exchange = new Sayings.Models.Exchange parent_exchange_id: 123, parent_entry_id: 456, parent_comment_id: 789
        exchangeView = new Sayings.Views.ShowExchange model: exchange
        @view.orderedChildren.unshift exchangeView

      it 'changes the browser url to the parent exchange/entry/comment ids', ->
        navigateSpy = sinon.spy Sayings.router, 'navigate'
        $( @view.render().el ).find( '#back-link' ).click()
        expect( navigateSpy ).toHaveBeenCalledWith '#e/123/456/789'
        Sayings.router.navigate.restore()

      it 'fires the router show method', ->
        showSpy = sinon.spy Sayings.router, 'show'
        $( @view.render().el ).find( '#back-link' ).click()
        expect( showSpy ).toHaveBeenCalledWith 123, 456, 789
        Sayings.router.show.restore()
        
    describe 'if there is not an exchange view in the manager', ->
      it 'does not change the browser url', ->
        navigateSpy = sinon.spy Sayings.router, 'navigate'
        $( @view.render().el ).find( '#back-link' ).click()
        expect( navigateSpy ).not.toHaveBeenCalled()
        Sayings.router.navigate.restore()

      it 'does not fire the router show method', ->
        showSpy = sinon.spy Sayings.router, 'show'
        $( @view.render().el ).find( '#back-link' ).click()
        expect( showSpy ).not.toHaveBeenCalled()
        Sayings.router.show.restore()

  describe 'adding exchange views', ->
    beforeEach ->
      # make an entry so as to differentiate the view from others
      entry = new Sayings.Models.Entry content: 'test'
      exchange = new Sayings.Models.Exchange
      exchange.set 'entries', [entry]
      @exchangeView = new Sayings.Views.ShowExchange model: exchange
      otherExchange = new Sayings.Models.Exchange
      otherExchangeView = new Sayings.Views.ShowExchange model: otherExchange
      @view.addFromLeft otherExchangeView

    describe 'from the left', ->
      it 'prepends the view to the exchange-children div', ->
        $el = $( @view.render().el )
        @view.addFromLeft @exchangeView
        expect( $el.find( '.exchange' ).first().html() ).toEqual $( @exchangeView.render().el ).html()

      it 'adds the view to the beginning of the ordered children array', ->
        @view.addFromLeft @exchangeView
        expect( @view.orderedChildren.first() ).toEqual @exchangeView

      it 'removes the last view from the ordered children array if there are more than two', ->
        jQuery.fx.off = true
        @view.render()

        exchangeTwo = new Sayings.Models.Exchange
        exchangeViewTwo = new Sayings.Views.ShowExchange model: exchangeTwo
        exchangeThree = new Sayings.Models.Exchange
        exchangeViewThree = new Sayings.Views.ShowExchange model: exchangeThree
        @view.addFromLeft exchangeViewTwo
        @view.addFromLeft exchangeViewThree
        leaveSpy = sinon.spy exchangeViewTwo, 'orderedLeave'
        @view.addFromLeft @exchangeView
        expect( leaveSpy ).toHaveBeenCalled()

    describe 'from the right', ->
      it 'appends the view to the exchange-children div', ->
        $el = $( @view.render().el )
        @view.addFromRight @exchangeView
        expect( $el.find( '.exchange' ).last().html() ).toEqual $( @exchangeView.render().el ).html()

      it 'adds the view to the beginning of the ordered children array', ->
        @view.addFromRight @exchangeView
        expect( @view.orderedChildren.last() ).toEqual @exchangeView

      it 'removes views from the beginning of the ordered children array if there are more than two', ->
        jQuery.fx.off = true
        @view.render()

        exchangeViewTwo = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        exchangeViewThree = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        exchangeViewFour = new Sayings.Views.ShowExchange model: new Sayings.Models.Exchange
        leaveSpyTwo = sinon.spy exchangeViewTwo, 'orderedLeave'
        leaveSpyThree = sinon.spy exchangeViewThree, 'orderedLeave'
        @view.addFromRight exchangeViewTwo
        @view.addFromRight exchangeViewThree
        @view.addFromRight exchangeViewFour
        @view.addFromRight @exchangeView
        expect( @view.orderedChildren.size() ).toEqual 2
        expect( leaveSpyTwo ).toHaveBeenCalled()
        expect( leaveSpyThree ).toHaveBeenCalled()
