class SayingsUp.Models.Exchange extends Backbone.Model
  paramRoot: 'exchange'

  defaults:
    content: null
  
class SayingsUp.Collections.ExchangesCollection extends Backbone.Collection
  model: SayingsUp.Models.Exchange
  url: '/exchanges'