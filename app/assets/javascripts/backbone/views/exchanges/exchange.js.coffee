class Sayings.Views.Exchange extends Backbone.View
  #events:
  #  "click .destroy" : "destroy"
      
  tagName: "tr"
  
  #destroy: () ->
  #  @model.destroy()
  #  this.remove()
    
  #  return false
    
  render: ->
    $( this.el ).html( JST['backbone/templates/exchanges/exchange']( { model: @model } ) )
    return this
