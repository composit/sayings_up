class Sayings.Models.ExchangeTag extends Backbone.Model
  idAttribute: 'current_user_tagging_id'
  paramRoot: 'tagging'

  defaults:
    number_of_taggings: 0
