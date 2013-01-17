class Sayings.Views.ShowTagging extends Support.CompositeView
  tagName: 'span'
  className: 'tagging'

  render: ->
    @$el.html JST['backbone/templates/taggings/show']
    @$( '.tag_name' ).html @model.get 'tag_name'
    return this
