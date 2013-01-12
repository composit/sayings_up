require 'spec_helper'

describe EntriesController do
  context 'POST' do
    let!( :current_user ) { signed_in_user_with_abilities @controller, [[:read, Exchange], [:create, Entry]] }
    let( :entry ) { Entry.new }
    let( :entries ) { stub( new: entry ) }
    let( :exchange ) { mock_model( Exchange, entries: entries ).as_null_object }
    let( :params ) { { exchange_id: 123, entry: {}, format: :json } }

    before do
      Exchange.stub( :find ).with( '123' ) { exchange }
    end

    it 'does not save if the user does not have the appropriate rights' do
      @controller.current_ability.cannot :create, Entry
      expect { post :create, params }.to raise_error CanCan::AccessDenied
    end

    it 'finds the appropriate exchange' do
      Exchange.should_receive( :find ).with '123'
      post :create, params
    end

    it 'assigns the current user' do
      entry.should_receive( :user_id= ).with current_user.id
      post :create, params
    end

    it 'saves the entry' do
      exchange.should_receive :save!
      post :create, params
    end

    describe 'with views' do
      render_views

      it 'responds with the entry' do
        post :create, params
        expect( response.body ).to match( /^{\"_id\":\"\w+\",\"html_content\":\"\",\"user_id\":\w+,\"exchange_id\":null,\"username\":null,\"comment_data\":\[\]}$/ )
      end
    end
  end
end
