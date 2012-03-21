class Sayings.Models.UserSession extends Backbone.Model
  url: ->
    if user_id = @get( 'user_id' )
      '/user_sessions/' + user_id
    else
      '/user_sessions'
