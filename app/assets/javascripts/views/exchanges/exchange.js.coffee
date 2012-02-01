Sayings.Views.Exchanges ||= {}

class Sayings.Views.Exchanges.Exchange extends Backbone.View
  template: JST["../templates/exchanges/exchange"]
  
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
