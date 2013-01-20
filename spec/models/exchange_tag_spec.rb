require 'spec_helper'

describe ExchangeTag do
  it 'has a tag name that can be set during initialization' do
    exchange_tag = ExchangeTag.new tag_name: 'tagname'
    expect( exchange_tag.tag_name ).to eq 'tagname'
  end

  it 'knows if it has been tagged by the current user' do
    exchange_tag = ExchangeTag.new current_username: 'testuser', usernames:['testuser']
    other_exchange_tag = ExchangeTag.new current_username: 'testuser', usernames: []
    expect( exchange_tag.owned_by_current_user ).to be_true
    expect( other_exchange_tag.owned_by_current_user ).to be_false
  end

  describe 'find by exchange' do
    let( :exchange ) { create :exchange }
    let( :exchange_tags ) { ExchangeTag.find_by_exchange exchange, 'testuser' }
    
    before do
      create_list :tagging, 3, exchange: exchange, tag_name: 'three'
      create_list :tagging, 5, exchange: exchange, tag_name: 'two'
      create :tagging, exchange: exchange, tag_name: 'one'
    end

    it 'create exchange_tags for each tagging' do
      ExchangeTag.should_receive( :new ).with( tag_name: anything(), usernames: anything(), current_username: 'testuser' ).exactly( 3 ).times
      exchange_tags
    end

    it 'returns exchange_tags for an exchange' do
      expect( exchange_tags.length ).to eq 3
      expect( exchange_tags.map( &:tag_name ) - ['one', 'two', 'three'] ).to eq []
    end

    it 'orders the tags in reverse by tagged count' do
      expect( exchange_tags.map( &:tag_name ) ).to eq ['two', 'three', 'one']
    end
  end
end
