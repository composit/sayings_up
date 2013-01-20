require 'spec_helper'

describe ExchangesController do
  context 'GET' do
    it 'does something undetermined'
  end

  context 'GET/1' do
    let( :exchange ) { double }
    let!( :current_user ) { signed_in_user_with_abilities @controller, [[:read, exchange]] }
    let( :params ) { { id: 123, format: :json } }

    before do
      Exchange.stub( :find ).with( '123' ) { exchange }
      current_user.stub( :username ) { 'testuser' }
      exchange.stub( :current_username= ).with 'testuser'
    end

    it 'assigns the exchange' do
      get :show, params
      expect( assigns[:exchange] ).to eq exchange
    end

    it 'sets the current username on the exchange' do
      exchange.should_receive( :current_username= ).with 'testuser'
      get :show, params
    end
  end
  
  context 'POST' do
    let( :exchange ) { Exchange.new }
    let( :params ) { { exchange: { initial_values: { content: 'new exchange' } }, format: :json } }
    let!( :current_user ) { signed_in_user_with_abilities @controller, [[:create, Exchange]] }

    before :each do
      Exchange.stub( :new_with_initial_values ) { exchange }
    end

    it 'does not save if the user does not have the appropriate rights' do
      @controller.current_ability.cannot :create, Exchange
      expect { post :create, params }.to raise_error CanCan::AccessDenied
    end

    it 'assigns the current user' do
      Exchange.should_receive( :new_with_initial_values ).with hash_including user_id: current_user.id
      post :create, params
    end

    it 'saves the exchange' do
      exchange.should_receive :save!
      post :create, params
    end

    describe 'with views' do
      render_views

      it 'responds with the exchange' do
        post :create, params
        expect( response.body ).to match( /^{\"_id\":\"\w+\",\"parent_exchange_id\":null,\"parent_entry_id\":null,\"parent_comment_id\":null,\"ordered_user_ids\":\[\],\"ordered_usernames\":\[\],\"entry_data\":\[\],\"exchange_tag_data\":\[\]}$/ )
      end
    end
  end
end
