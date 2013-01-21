require 'spec_helper'

describe ExchangeTag do
  it 'has a tag name that can be set during initialization' do
    exchange_tag = ExchangeTag.new tag_name: 'tagname'
    expect( exchange_tag.tag_name ).to eq 'tagname'
  end

  describe 'find by exchange' do
    let( :exchange ) { create :exchange }
    let( :user ) { create :user }
    let( :exchange_tags ) { ExchangeTag.find_by_exchange exchange, user }
    let!( :user_tagging ) { create :tagging, exchange: exchange, tag_name: 'one', user: user }
    
    before do
      create_list :tagging, 3, exchange: exchange, tag_name: 'three'
      create_list :tagging, 5, exchange: exchange, tag_name: 'two'
    end

    it 'create exchange_tags for each tagging' do
      ExchangeTag.should_receive( :new ).with( tag_name: anything(), current_user_tagging_id: anything() ).exactly( 3 ).times
      exchange_tags
    end

    it 'returns exchange_tags for an exchange' do
      expect( exchange_tags.length ).to eq 3
      expect( exchange_tags.map( &:tag_name ) - ['one', 'two', 'three'] ).to eq []
    end

    it 'sets the current user tagging id' do
      tagging_ids = exchange_tags.map { |exchange_tag| { exchange_tag.tag_name => exchange_tag.current_user_tagging_id } }
      expect( tagging_ids - [{ 'one' => user_tagging.id }, { 'two' => nil }, { 'three' => nil }] ).to eq []
    end

    it 'orders the tags in reverse by tagged count' do
      expect( exchange_tags.map( &:tag_name ) ).to eq ['two', 'three', 'one']
    end

    it 'does not crash if there is no current user' do
      expect( ExchangeTag.find_by_exchange exchange, nil ).to_not raise_error RuntimeError
    end
  end
end
