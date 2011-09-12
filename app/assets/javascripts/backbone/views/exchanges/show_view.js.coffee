SayingsUp.Views.Exchanges ||= {}

class SayingsUp.Views.Exchanges.ShowView extends Backbone.View
  template: JST["backbone/templates/exchanges/show"]
   
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    return this