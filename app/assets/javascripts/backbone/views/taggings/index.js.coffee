class Sayings.Views.TaggingsIndex extends Support.CompositeView
  initialize: ->
    @listenTo @collection, 'add', @render
    @listenTo @collection, 'change', @render

  render: ->
    @$el.html ''
    @addTaggings()
    @newTagging() if Sayings.currentUserSession and Sayings.currentUserSession.get 'user_id'
    return this

  addTaggings: ->
    @collection.each @addTagging

  addTagging: ( tagging ) =>
    taggingView = new Sayings.Views.ShowTagging model: tagging
    @$el.append taggingView.render().el

  newTagging: ->
    newTaggingView = new Sayings.Views.NewTagging collection: @collection
    @$el.append newTaggingView.render().el
