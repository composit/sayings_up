class Sayings.Collections.ExchangeTags extends Backbone.Collection
  model: Sayings.Models.ExchangeTag

  addOrOwn: ( newModel ) ->
    foundModel = _.find @models, ( model ) ->
      model.get( 'tag_name' ) == newModel.get 'tag_name'
    modelToAdd = foundModel ? newModel
    @add modelToAdd
    modelToAdd.set 'current_user_tagging_id', newModel.get( 'current_user_tagging_id' )
    modelToAdd.set 'number_of_taggings', 1 + parseInt( modelToAdd.get( 'number_of_taggings' ) )

  removeOrDisown: ( model ) =>
    model.set 'current_user_tagging_id', null
    if parseInt( model.get( 'number_of_taggings' ) ) > 1
      model.set 'number_of_taggings', parseInt( model.get( 'number_of_taggings' ) - 1 )
    else
      @remove model
