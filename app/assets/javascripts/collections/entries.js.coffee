class Sayings.Collections.Entries extends Backbone.Collection
  #initialize: ( options ) ->
  #  @url = '/exchanges/' + options.exchange_id + '/entries'

  model: Sayings.Models.Entry
  #url: '/exchanges/' + @exchange_id + '/entries'
