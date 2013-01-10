require 'spec_helper'

describe CommentsController do
  context 'POST' do
    let!( :current_user ) { signed_in_user_with_abilities @controller, [[:read, Exchange],[:read, Entry],[:create, Comment]] }
    let( :comment ) { Comment.new }
    let( :entry ) { mock_model Entry, comments: stub( new: comment ), exchange: exchange }
    let( :entries ) { stub }
    let( :exchange ) { mock_model( Exchange, entries: entries ).as_null_object }
    let( :params ) { { exchange_id: 123, entry_id: 456, comment: {}, format: :json } }

    before :each do
      Exchange.stub( :find ).with( '123' ) { exchange }
      entries.stub( :find ).with( '456' ) { entry }
    end

    after :each do
      post :create, params
    end

    it 'finds the appropriate exchange' do
      Exchange.should_receive( :find ).with '123'
    end

    it 'finds the appropriate entry' do
      entries.should_receive( :find ).with '456'
    end

    it 'assigns the current user' do
      comment.should_receive( :user_id= ).with current_user.id
    end

    it 'saves the comment' do
      exchange.should_receive :save!
    end

    describe 'with views' do
      render_views

      it 'responds with the comment' do
        post :create, params
        expect( response.body ).to match( /{\"_id\":\"\w+\",\"html_content\":\"\",\"exchange_id\":null,\"entry_id\":null,\"entry_user_id\":null,\"child_exchange_data\":null,\"user_username\":null}/ )
      end
    end
  end
end
