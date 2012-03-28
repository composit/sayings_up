class Sayings.Models.UserSession extends Backbone.Model
  idAttribute: '_id'

  url: ->
    if @get( '_id' )
      '/user_sessions/' + @get( '_id' )
    else
      '/user_sessions'
