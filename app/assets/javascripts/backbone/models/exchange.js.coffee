class Sayings.Models.Exchange extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'exchange'

  defaults:
    content: null
    ordered_user_ids: []

  initialize: ->
    @parseEntries()

  parseEntries: =>
    @entries = new Sayings.Collections.Entries @get 'entries'
    @entries.url = '/exchanges/' + @id + '/entries'
