class Sayings.Views.NewEntry extends Backbone.View
  id: 'new-entry'

  events:
    'click #respond-link': 'new'

  render: ->
    $( @el ).html '<a id="respond-link" href="#">respond</a>'
    return this

  new: ->
    $( @el ).html JST['entries/new']
    return false
