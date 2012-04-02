class Sayings.Views.ShowExchange extends Backbone.View
  className: 'exchange'
  template: JST["exchanges/show"]
   
  render: ->
    $( @el ).html @template( @model )

    self = this
    @model.entries.each ( entry ) ->
      entryView = new Sayings.Views.ShowEntry( { model: entry } )
      self.$( "#entries" ).append( entryView.render().el )
    @model.get( 'user_ids' ).forEach ( user_id ) ->
      alert Sayings.currentUser.id
      if( user_id == Sayings.currentUser.id )
        alert user_id
        #self.$( "#entries" ).append( "<a href='#'>responds</a>" )
    return this

  #addEntry: (entry) ->
  #  entryView = new Sayings.Views.ShowEntry( { model: entry } )
