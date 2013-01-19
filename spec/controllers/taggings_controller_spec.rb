require 'spec_helper'

describe TaggingsController do
  context 'POST' do
    #TODO this is a mess of stubs, etc
    let!( :current_user ) { signed_in_user_with_abilities @controller, [[:read, Exchange], [:create, Tagging]] }

    let( :tagging ) { Tagging.new }
    let( :taggings ) { stub new: tagging }
    let( :exchange ) { mock_model( Exchange, taggings: taggings ).as_null_object }
    let( :params ) { { exchange_id: 123, tagging: { tag_name: 'newtag' }, format: :json } }

    before do
      Exchange.stub( :find ).with( '123' ) { exchange }
      tagging.stub save!: true
    end

    it 'does not save if the user does not have the appropriate rights' do
      @controller.current_ability.cannot :create, Tagging
      expect { post :create, params }.to raise_error CanCan::AccessDenied
    end

    it 'assigns the current user' do
      tagging.should_receive( :user_id= ).with current_user.id
      post :create, params
    end

    describe 'finds or saves the tagging' do
      describe 'if there is a duplicate' do
        let( :duplicate_tagging ) { double }

        before do
          Tagging.stub( :where ).with( user_id: current_user.id, exchange_id: anything(), tag_id: anything() ) { [duplicate_tagging] }
        end

        it 'does not save the tagging' do
          tagging.should_not_receive :save!
          post :create, params
        end

        it 'returns the duplicate if there is one' do
          post :create, params
          assigns[:tagging].should eq duplicate_tagging
        end
      end

      describe 'if there is no duplicate' do
        before do
          Tagging.stub( :where ).with( user_id: current_user.id, exchange_id: anything(), tag_id: anything() ) { [] }
        end

        it 'saves the tagging if there is no duplicate' do
          tagging.should_receive :save!
          post :create, params
        end

        it 'returns the new tagging' do
          post :create, params
          expect( assigns[:tagging] ).to eq tagging
        end
      end
    end

    describe 'with views' do
      render_views

      it 'responds with the tagging' do
        post :create, params
        expect( response.body ).to match( /{\"tag_name\":null}/ )
      end
    end
  end
end
