class Sayings.Collections.ExchangeTags extends Backbone.Collection
  model: Sayings.Models.ExchangeTag

  addOrOwn: ( newModel ) ->
    foundModel = _.find @models, ( model ) ->
      model.get( 'tag_name' ) == newModel.get 'tag_name'
    modelToAdd = foundModel ? newModel
    @add modelToAdd
    modelToAdd.set 'owned_by_current_user', true
