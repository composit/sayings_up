require 'spec_helper'

describe ExchangeTag do
  it 'has a tag name that can be set during initialization' do
    exchange_tag = ExchangeTag.new tag_name: 'tagname'
    expect( exchange_tag.tag_name ).to eq 'tagname'
  end

  describe 'find by exchange' do
    let( :exchange ) { create :exchange }
    let( :exchange_tags ) { ExchangeTag.find_by_exchange exchange }
    
    before do
      create_list :tagging, 3, exchange: exchange, tag_name: 'three'
      create_list :tagging, 5, exchange: exchange, tag_name: 'two'
      create :tagging, exchange: exchange, tag_name: 'one'
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
