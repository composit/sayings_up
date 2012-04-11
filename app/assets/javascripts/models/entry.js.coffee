class Sayings.Models.Entry extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'entry'

  defaults:
    content: null

  initialize: ->
    @parseComments()

  parseComments: =>
    @comments = new Sayings.Collections.Comments @get 'comments'
