class Sayings.Views.NewExchange extends Backbone.View
  className: 'new-exchange'

  initialize: ->
    _.bindAll( this, 'render', 'new', 'save', 'saved' )
    @model.url = '/exchanges'

  events:
    'click .respond-link': 'new'
    'submit form#new-exchange-form': 'save'

  render: ->
    $( @el ).html '<button class="respond-link" href="#">respond</a>'
    return this

  new: ->
    $( @el ).html JST['backbone/templates/exchanges/new']
    return false

  save: ->
    if vals = @model.get 'initial_values'
      vals.content = @$( '#content' ).val()
      @model.set 'initial_values', vals
    @model.save(
      {}
      success: @saved
    )
    return false

  saved: ->
    @model.parseEntries()
    @options.parent_comment.set( 'child_exchange_data', { id: @model.get( '_id' ), entry_count: @model.entries.length } )
  #template: JST["backbone/templates/exchanges/new"]
  
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
