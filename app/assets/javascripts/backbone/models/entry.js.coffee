class Sayings.Models.Entry extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'entry'

  defaults:
    content: null
    comment_data: []

  initialize: ->
    @on 'sync', @parseCommentData
    @parseCommentData()

  parseCommentData: =>
    @comments = new Sayings.Collections.Comments @get 'comment_data'
    @comments.url = '/exchanges/' + @get( 'exchange_id' ) + '/entries/' + @id + '/comments'
