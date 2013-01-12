require 'spec_helper'

describe Tagging do
  subject { build :tagging }

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

  it 'requires a user' do
    subject.user = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:user] ).to eq ["can't be blank"]
  end

  it 'requires an exchange' do
    subject.exchange = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:exchange] ).to eq ["can't be blank"]
  end

  it 'requires a non-blank tag name' do
    subject.tag_name = ''
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:tag_name] ).to eq ["can't be blank"]
  end
end

