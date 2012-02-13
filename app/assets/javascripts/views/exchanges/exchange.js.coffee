class Sayings.Views.Exchange extends Backbone.View
  template: JST["exchanges/exchange"]
  
  #events:
  #  "click .destroy" : "destroy"
      
  tagName: "tr"
  
  #destroy: () ->
  #  @model.destroy()
  #  this.remove()
    
  #  return false
    
  render: ->
    $( this.el ).html( @template( { model: @model } ) )
    return this
