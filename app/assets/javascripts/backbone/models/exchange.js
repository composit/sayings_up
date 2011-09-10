var Exchange = Backbone.Model.extend( {
  url : function() {
    var base = 'exchanges';
    if ( this.isNew() ) return base;
    return base + ( base.charAt( base.length - 1 ) == "/" ? '' : '/' ) + this.id;
  }
} );