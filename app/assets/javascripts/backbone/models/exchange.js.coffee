class Sayings.Models.Exchange extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'exchange'

  defaults:
    content: null
    ordered_user_ids: []
    ordered_usernames: []
    entry_data: []

  initialize: ->
    @on 'change:entry_data', @parseEntryData
    @parseEntryData()

  parseEntryData: =>
    @entries = new Sayings.Collections.Entries @get 'entry_data'
    @entries.url = '/exchanges/' + @id + '/entries'
