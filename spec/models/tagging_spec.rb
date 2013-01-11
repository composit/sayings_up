require 'spec_helper'

describe Tagging do
  it 'has a tag name' do
    subject.tag_name = 'test tag'
    subject.save!
    expect( subject.reload.tag_name ).to eq 'test tag'
  end

  it 'belongs to a user' do
    user = create :user
    subject.user = user
    subject.save!
    expect( subject.reload.user ).to eq user
  end

  it 'belongs to an exchange' do
    exchange = create :exchange
    subject.exchange = exchange
    subject.save!
    expect( subject.reload.exchange ).to eq exchange
  end
end

