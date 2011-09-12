SayingsUp.Views.Exchanges ||= {}

class SayingsUp.Views.Exchanges.NewView extends Backbone.View    
  template: JST["backbone/templates/exchanges/new"]
  
  events:
    "submit #new-exchange": "save"
    
  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )
    
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
      
    @model.unset("errors")
    
    @collection.create(@model.toJSON(), 
      success: (exchange) =>
        @model = exchange
        window.location.hash = "/#{@model.id}"
        
      error: (exchange, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this