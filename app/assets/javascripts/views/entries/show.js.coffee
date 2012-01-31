SayingsUp.Views.Entries ||= {}

class SayingsUp.Views.Entries.Show extends Backbone.View
  template: JST["../templates/entries/show"]

  render: ->
    $( this.el ).html( "" )
    return this
