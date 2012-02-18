class Sayings.Models.Exchange extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'exchange'

  defaults:
    content: null

  initialize: () ->
    @parseEntries()

  parseEntries: () ->
    @entries = new Sayings.Collections.Entries( @get( 'entries' ) )

#  initialize: () ->
#    if @has( 'entries' ) ->
#      @setEntries( new Sayings.Collections.Entries.reset( @get( 'entries' ) ) )

#  setEntries: ( entries ) ->
#    @entries = entries
