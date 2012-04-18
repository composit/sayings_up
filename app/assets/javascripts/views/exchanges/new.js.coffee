class Sayings.Views.NewExchange extends Backbone.View
  className: 'new-exchange'

  initialize: ->
    _.bindAll( this, 'render', 'new', 'save', 'saved' )
    @model = new Sayings.Models.Exchange()
    @model.url = '/exchanges'

  events:
    'click .respond-link': 'new'
    'submit form#new-exchange-form': 'save'

  render: ->
    $( @el ).html '<a class="respond-link" href="#">respond</a>'
    return this

  new: ->
    $( @el ).html JST['exchanges/new']
    return false

  save: ->
    @model.save(
      { content: @$( '#content' ).val() }
      success: @saved
    )
    return false

  saved: ->
    console.log 'good save, bro'
  #template: JST["exchanges/new"]
  
  #events:
  #  "submit #new-exchange": "save"
    
  #constructor: (options) ->
  #  super(options)
  #  @model = new @collection.model()
  #
  #  @model.bind("change:errors", () =>
  #    this.render()
  #  )
    
  #save: (e) ->
  #  e.preventDefault()
  #  e.stopPropagation()
  #    
  #  @model.unset("errors")
  #  
  #  @collection.create(@model.toJSON(),
  #    success: (exchange) =>
  #      @model = exchange
  #      window.location.hash = "/#{@model.id}"
  #      
  #    error: (exchange, jqXHR) =>
  #      @model.set({errors: $.parseJSON(jqXHR.responseText)})
  #  )
    
  #render: ->
  #  $(this.el).html(@template(@model.toJSON() ))
  #  
  #  this.$("form").backboneLink(@model)
  #  
  #  return this
