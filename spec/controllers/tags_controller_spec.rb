require 'spec_helper'

describe TagsController do
  context 'GET' do
    it 'returns all tags in order' do
      tags = double
      tags_with_zeroes = double delete_if: tags
      unordered_tags = double sort: tags_with_zeroes
      Tag.stub( :all ) { unordered_tags }
      get :index
      expect( assigns[:tags] ).to eq tags
    end
  end

  context 'GET/1' do
    it 'returns a specific tag' do
      tag = Tag.new
      Tag.stub( :find ).with( '123' ) { tag }
      get :show, id: '123'
      expect( assigns[:tag] ).to eq tag
    end
  end
end
