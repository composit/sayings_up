require 'spec_helper'

describe Comment do
  it 'is valid' do
    expect( build :comment ).to be_valid
  end

  context 'exchange and entry values' do
    let( :user ) { create :user }
    let!( :exchange ) { create :exchange, entries: [entry] }
    let!( :entry ) { create :entry, comments: [comment], user: user }
    let( :comment ) { build :comment }

    specify { expect( comment.entry_user_id ).to eq user.id }
    specify { expect( comment.exchange_id ).to eq exchange.id }
    specify { expect( comment.entry_id ).to eq entry.id }

    context 'child exchange' do
      let!( :child_exchange ) { create( :exchange, parent_comment_id: comment.id ) }
      
      it 'finds the child exchange' do
        expect( comment.child_exchange ).to eq child_exchange
      end

      it 'returns info about a child exchange' do
        child_exchange.entries = create_list :entry, 11
        expect( comment.child_exchange_data ).to eq( { id: child_exchange.id, entry_count: 11 } )
      end
    end
  end

  it 'returns the user\'s username' do
    subject.user = build :user, username: 'test user'
    expect( subject.user_username ).to eq 'test user'
  end

  it "requires the existence of a user" do
    comment = build :comment, user: nil
    expect( comment ).not_to be_valid
    expect( comment.errors[:user].length ).to eq 1
    expect( comment.errors[:user] ).to include "can't be blank"
  end
end
