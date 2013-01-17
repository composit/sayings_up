class Sayings.Models.Exchange extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'exchange'

  defaults:
    ordered_user_ids: []
    ordered_usernames: []
    entry_data: []

  initialize: ->
    @on 'change:entry_data', @parseEntryData
    @parseEntryData()
    @parseTaggingData()

  parseEntryData: =>
    @entries = new Sayings.Collections.Entries @get 'entry_data'
    @entries.url = '/exchanges/' + @id + '/entries'

  parseTaggingData: =>
    @taggings = new Sayings.Collections.Taggings @get 'tagging_data'
    @taggings.url = '/exchanges/' + @id + '/taggings'
