describe 'Sayings.Collections.ExchangeTags', ->
  beforeEach ->
    @collection = new Sayings.Collections.ExchangeTags()

  it 'contains instances of Sayings.Model.ExchangeTag', ->
    expect( @collection.model ).toEqual Sayings.Models.ExchangeTag

  describe 'add or own', ->
    beforeEach ->
      @newExchangeTag = new Sayings.Models.ExchangeTag tag_name: 'newtag', current_user_tagging_id: '123'
      @existingExchangeTag = new Sayings.Models.ExchangeTag tag_name: 'existingTag', number_of_taggings: '3'
      @collection.add @existingExchangeTag
      @newExistingExchangeTag = new Sayings.Models.ExchangeTag tag_name: 'existingTag', current_user_tagging_id: '234'

    it 'adds an exchange tag if it is not already in the collection', ->
      @collection.addOrOwn @newExchangeTag
      expect( @collection.models ).toContain @newExchangeTag

    it 'does not add an exchange if it is already included', ->
      @collection.addOrOwn @newExistingExchangeTag
      expect( @collection.models ).not.toContain @newExistingExchangeTag

    describe 'it owns', ->
      it 'a new exchange tag', ->
        @collection.addOrOwn @newExchangeTag
        expect( @newExchangeTag.get 'current_user_tagging_id' ).toEqual '123'
        expect( @newExchangeTag.get 'number_of_taggings' ).toEqual 1

      it 'an existing exchange tag', ->
        @collection.addOrOwn @newExistingExchangeTag
        expect( @existingExchangeTag.get 'current_user_tagging_id' ).toEqual '234'
        expect( @existingExchangeTag.get 'number_of_taggings' ).toEqual 4

  describe 'remove or disown', ->
    beforeEach ->
      @existingExchangeTag = new Sayings.Models.ExchangeTag tag_name: 'existingTag', number_of_taggings: '3', current_user_tagging_id: '123'
      @collection.add @existingExchangeTag

    it 'disowns the exchange tag', ->
      @collection.removeOrDisown @existingExchangeTag
      expect( @existingExchangeTag.get 'current_user_tagging_id' ).toBeFalsy()
      expect( @existingExchangeTag.get 'number_of_taggings' ).toEqual 2

    it 'removes the exchange tag if it is the last tagging', ->
      @existingExchangeTag.set 'number_of_taggings', '1'
      @collection.removeOrDisown @existingExchangeTag
      expect( @collection.get @existingExchangeTag ).toBeFalsy()
