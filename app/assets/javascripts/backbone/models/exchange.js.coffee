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
    @on 'change:exchange_tag_data', @parseExchangeTagData
    @parseExchangeTagData()

  parseEntryData: =>
    @entries = new Sayings.Collections.Entries @get 'entry_data'
    @entries.url = '/exchanges/' + @id + '/entries'
    @trigger 'changedEntries'

  parseExchangeTagData: =>
    @exchangeTags = new Sayings.Collections.ExchangeTags @get 'exchange_tag_data'
    @exchangeTags.url = '/exchanges/' + @id + '/taggings'
    @trigger 'changedEntries'
