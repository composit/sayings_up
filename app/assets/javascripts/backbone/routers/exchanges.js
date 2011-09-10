SayingsUp.Routers.Exchanges = Backbone.Router.extend( {
  routes: {
    "exchanges/:id": "edit",
    "": "index",
    "new": "newExchange"
  },

  edit: function( id ) {
    var exchange = new Exchange( { id: id } );
    exchange.fetch( {
      success: function( model, resp ) {
        new App.Views.Edit( { model: exchange } );
      },
      error: function() {
        new Error( { message: 'Could not find that exchange.' } );
        window.location.hash = '#';
      }
    } );
  },

  index: function() {
    $.getJSON( '/exchanges', function( data ) {
      if( data ) {
        var exchanges = _( data ).map( function( i ) { return new Exchange( i ); } );
        new App.Views.Index( { exchanges: exchanges } );
      } else {
        new Error( { message: "Error loading exchanges." } );
      }
    } );
  },

  newExchange: function() {
    new App.Views.Edit( { model: new Exchange() } );
  }
} );
