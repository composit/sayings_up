SayingsUp.Views.Exchanges ||= {}

class SayingsUp.Views.Exchanges.EditView extends Backbone.View
  template : JST["backbone/templates/exchanges/edit"]
  
  events :
    "submit #edit-exchange" : "update"
    
  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    @model.save(null,
      success : (exchange) =>
        @model = exchange
        window.location.hash = "/#{@model.id}"
    )
    
  render : ->
    $(this.el).html(this.template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this