class SayingsUp.Collections.Entries extends Backbone.Collection
  initialize: ( options ) ->
    @url = '/exchanges/' + options.exchange_id + '/entries'

  model: SayingsUp.Models.Entry
  #url: '/exchanges/' + @exchange_id + '/entries'
