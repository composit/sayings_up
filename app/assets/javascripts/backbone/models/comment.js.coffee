class Sayings.Models.Comment extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'comment'

  defaults:
    html_content: null
