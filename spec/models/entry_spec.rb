require 'spec_helper'

describe Entry do
  it 'creates a new instance given valid attributes' do
    expect( build :entry ).to be_valid
  end

  it 'only includes specific data in the json' do
    expect( subject.to_json ).to match /^{\"_id\":\"\w+\",\"content\":null,\"user_id\":null,\"exchange_id\":null,\"comments\":\[\]}$/
  end

  it 'contains comments' do
    entry = build :entry
    entry.comments << build_list( :comment, 11 )
    entry.save!
    expect( entry.reload.comments.length ).to eq 11
  end

  it 'belongs to a user' do
    user = User.new
    subject.user = user
    expect( subject.user ).to eq user
  end

  it 'persists the user to the database' do
    user = create :user
    entry = build :entry
    entry.user = user
    entry.save!
    expect( entry.reload.user ).to eq user
  end

  it 'returns the exchange id' do
    exchange = create :exchange
    entry = Entry.new
    exchange.entries << entry
    expect( entry.exchange_id ).to eq exchange.id
  end

  it 'requires the existence of a user' do
    entry = build :entry, user: nil
    expect( entry ).not_to be_valid
    expect( entry.errors[:user].length ).to eq 1
    expect( entry.errors[:user] ).to include( 'can\'t be blank' )
  end
end
