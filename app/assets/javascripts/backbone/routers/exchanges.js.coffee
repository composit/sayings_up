App.Routers.Exchanges = Backbone.Router.extend
  routes:
#    "exchanges/:id": "show"
    "": "index"

#  show: ( id ) ->
#    exchange = new Exchange( { id: id } )
#    exchange.fetch
#      success: ( model, resp ) ->
#        new App.Views.Show( { model: exchange } )
#      error: ->
#        new Error( { message: 'Could not find that exchange.' } )
#        window.location.hash = '#'

  index: ->
    $.getJSON '/exchanges', ( data ) ->
      if( data )
        exchanges = _( data ).map ( i ) ->
          new App.Models.Exchange( i )
        new App.Views.Index( { exchanges: exchanges } )
      else
        new Error( { message: "Error loading exchanges." } )
