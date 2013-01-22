require 'spec_helper'

describe Tag do
  subject { build :tag }

  it 'has a name' do
    subject.name = 'test'
    subject.save!
    expect( subject.reload.name ).to eq 'test'
  end

  it 'requires a name' do
    subject.name = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:name] ).to eq ["can't be blank"]
  end

  it 'requires a unique name' do
    create :tag, name: 'unique'
    subject.name = 'unique'
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:name] ).to eq ["is already taken"]
  end

  it 'has many taggings' do
    subject.save!
    create_list :tagging, 11, tag: subject
    expect( subject.reload.taggings.length ).to eq 11
  end

  it 'has many exchanges through taggings' do
    subject.save!
    exchange_one = create :exchange
    exchange_two = create :exchange
    exchange_three = create :exchange
    create :tagging, tag: subject, exchange: exchange_one
    create :tagging, exchange: exchange_two
    create :tagging, tag: subject, exchange: exchange_three
    expect( subject.exchanges ).to eq [exchange_one, exchange_three]
  end
end
