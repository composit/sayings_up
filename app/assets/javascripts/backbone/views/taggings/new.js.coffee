class Sayings.Views.NewTagging extends Backbone.View
  id: 'new-tag'

  events:
    'click #new-tag-link': 'new'
    'submit form#new-tag-form': 'save'

  render: ->
    @$el.html '<a id="new-tag-link" href="#">new tag</a>'
    return this

  new: ->
    @model = new Sayings.Models.Tagging()
    @model.collection = @collection
    @$el.html JST['backbone/templates/taggings/new']
    return false

  save: ->
    @model.save(
      { tag_name: @$( '#tag_name' ).val() }
      success: @saved
    )
    return false

  saved: ( model ) =>
    @collection.add model
