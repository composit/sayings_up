class Sayings.Views.ExchangesIndex extends Backbone.View
  initialize: ->
    _.bindAll( this, 'addOne', 'addAll', 'render' )
    #@options.exchanges.bind('reset', @addAll)
       
  render: ->
    $( @el ).html JST["exchanges/index"]( collection: @collection )
    @addAll()
    return this
   
  addAll: ->
    @collection.each @addOne
  
  addOne: ( exchange ) ->
    view = new Sayings.Views.Exchange( model : exchange )
    @$( "tbody" ).append view.render().el
