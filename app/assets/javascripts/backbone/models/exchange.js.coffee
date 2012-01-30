class SayingsUp.Models.Exchange extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'exchange'

  defaults:
    content: null
  
class SayingsUp.Collections.Exchanges extends Backbone.Collection
  model: SayingsUp.Models.Exchange
  url: '/exchanges'
