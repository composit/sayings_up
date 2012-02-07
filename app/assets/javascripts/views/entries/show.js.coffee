class Sayings.Views.ShowEntry extends Backbone.View
  template: JST["entries/show"]

  render: ->
    $( this.el ).html( "" )
    return this
