class Sayings.Views.ExchangesIndex extends Backbone.View
  template: JST["exchanges/index"]
    
  initialize: () ->
    #_.bindAll(this, 'addOne', 'addAll', 'render')
    
    #@options.exchanges.bind('reset', @addAll)
   
  #addAll: () ->
  #  @options.exchanges.each(@addOne)
  
  #addOne: (exchange) ->
  #  view = new Sayings.Views.Exchanges.Exchange({model : exchange})
  #  @$("tbody").append(view.render().el)
       
  render: () ->
    $( @el ).html( @template( { exchanges: @collection } ) )
    
    self = this
    @collection.each ( exchange ) ->
      exchangeView = new Sayings.Views.Exchange( { model: exchange } )
      self.$( "tbody" ).append( exchangeView.render().el )

    #@addAll()
    return this
