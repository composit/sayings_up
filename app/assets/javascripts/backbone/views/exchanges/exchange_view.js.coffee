SayingsUp.Views.Exchanges ||= {}

class SayingsUp.Views.Exchanges.ExchangeView extends Backbone.View
  template: JST["backbone/templates/exchanges/exchange"]
  
  events:
    "click .destroy" : "destroy"
      
  tagName: "tr"
  
  destroy: () ->
    @model.destroy()
    this.remove()
    
    return false
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))    
    return this