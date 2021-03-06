require 'spec_helper'

describe Tagging do
  subject { build :tagging }

  it 'belongs to a tag' do
    tag = create :tag
    subject.tag = tag
    subject.save!
    expect( subject.reload.tag ).to eq tag
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
    expect( subject.errors[:user_id] ).to eq ["can't be blank"]
  end

  it 'requires an exchange' do
    subject.exchange = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:exchange] ).to eq ["can't be blank"]
  end

  it 'requires a tag' do
    subject.tag = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:tag] ).to eq ["can't be blank"]
  end

  it 'requires a user id to be unique given exchange and tag' do
    subject.user = create :user
    subject.exchange = create :exchange
    subject.tag = create :tag
    create :tagging, user: subject.user, exchange: subject.exchange, tag: subject.tag
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a.length ).to eq 1
    expect( subject.errors[:user_id] ).to eq ["is already taken"]
  end

  it 'returns a tag name' do
    subject.tag.name = 'testtag'
    expect( subject.tag_name ).to eq 'testtag'
  end

  describe 'tag_name=' do
    let!( :existing_tag ) { create :tag, name: 'existingtag' }

    it 'creates a new tag if one does not exist' do
      subject
      expect { subject.tag_name = 'newtag' }.to change{ Tag.count }.by 1
      subject.save!
      expect( subject.reload.tag_name ).to eq 'newtag'
    end

    it 'finds an existing tag' do
      subject.tag_name = 'existingtag'
      expect { subject.save! }.to_not change{ Tag.count }
      expect( subject.reload.tag ).to eq existing_tag
    end
  end

  it 'returns a username' do
    subject.user = build :user, username: 'test tag user'
    expect( subject.username ).to eq 'test tag user'
  end
end
