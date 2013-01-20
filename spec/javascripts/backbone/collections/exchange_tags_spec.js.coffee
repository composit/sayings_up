describe 'Sayings.Collections.ExchangeTags', ->
  beforeEach ->
    @collection = new Sayings.Collections.ExchangeTags()

  it 'contains instances of Sayings.Model.ExchangeTag', ->
    expect( @collection.model ).toEqual Sayings.Models.ExchangeTag

  describe 'add or own', ->
    beforeEach ->
      @newExchangeTag = new Sayings.Models.ExchangeTag tag_name: 'newtag'
      @existingExchangeTag = new Sayings.Models.ExchangeTag tag_name: 'existingTag'
      @collection.add @existingExchangeTag
      @newExistingExchangeTag = new Sayings.Models.ExchangeTag tag_name: 'existingTag'

    it 'adds an exchange tag if it is not already in the collection', ->
      @collection.addOrOwn @newExchangeTag
      expect( @collection.models ).toContain @newExchangeTag

    it 'does not add an exchange if it is already included', ->
      @collection.addOrOwn @newExistingExchangeTag
      expect( @collection.models ).not.toContain @newExistingExchangeTag

    it 'owns the exchange tag', ->
      @collection.addOrOwn @newExchangeTag
      @collection.addOrOwn @newExistingExchangeTag
      expect( @newExchangeTag.get 'owned_by_current_user' ).toBeTruthy()
      expect( @existingExchangeTag.get 'owned_by_current_user' ).toBeTruthy()
