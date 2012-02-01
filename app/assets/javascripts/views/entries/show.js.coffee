class Sayings.Views.Entry extends Backbone.View
  template: JST["entries/show"]

  render: ->
    $( this.el ).html( "" )
    return this
