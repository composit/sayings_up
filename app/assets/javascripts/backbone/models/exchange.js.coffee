#Exchange = Backbone.Model.extend({})

#Exchanges = Backbone.Collection.extend
#  url: "/exchanges"
#  model: Exchange

class App.Models.Exchange extends Backbone.Model

class App.Collections.Exchanges extends Backbone.Collection
  url: "/exchanges"
  model: App.Models.Exchange
