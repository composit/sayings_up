SayingsUp.Views.Exchanges ||= {}

class SayingsUp.Views.Exchanges.IndexView extends Backbone.View
  template: JST["backbone/templates/exchanges/index"]
    
  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.exchanges.bind('reset', @addAll)
   
  addAll: () ->
    @options.exchanges.each(@addOne)
  
  addOne: (exchange) ->
    view = new SayingsUp.Views.Exchanges.ExchangeView({model : exchange})
    @$("tbody").append(view.render().el)
       
  render: ->
    $(@el).html(@template(exchanges: @options.exchanges.toJSON() ))
    @addAll()
    
    return this