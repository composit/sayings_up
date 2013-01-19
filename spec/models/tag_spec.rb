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
end
