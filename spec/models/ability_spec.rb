require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let( :user ) { create :user }
  let( :ability ) { Ability.new user }

  it { should be_able_to :read, Exchange.new }
  it { should be_able_to :create, User.new }

  context 'exchanges' do
    let( :parent_entry ) { create :entry, user: user }
    let( :parent_exchange ) { build :exchange, entries: [parent_entry] }
    let( :initial_entry ) { create :entry }
    let( :response_entry ) { create :entry, user: user }
    let( :exchange ) { build :exchange, parent_exchange: parent_exchange, parent_entry_id: parent_entry.id, entries: [initial_entry, response_entry] }

    it { should be_able_to :create, exchange }

    it 'is not able to create an exchange if it is not a user in the exchange' do
      response_entry.user = create :user
      expect( ability ).not_to be_able_to :create, exchange
    end

    it 'is not able to create an exchange if it is not the user for the parent entry' do
      parent_entry.user = create :user
      expect( ability ).not_to be_able_to :create, exchange
    end

    it 'is able to update the exchange if it is a user in the exchange' do
      exchange.save!
      expect( ability ).to be_able_to :update, exchange
    end

    it 'is not able to update an exchange if it is not a user in the exchange' do
      response_entry.user = create :user
      expect( ability ).not_to be_able_to :update, exchange
    end
  end

  context 'entries' do
    let( :exchange ) { create :exchange }
    let( :new_entry ) { exchange.entries.build }

    before :each do
      exchange.entries << build( :entry, user: user )
    end

    it { should be_able_to :read, Entry.new }

    it 'is able to create an entry if it is a user on the entry\'s exchange' do
      expect( ability ).to be_able_to :create, new_entry
    end

    it 'is not able to create an entry if it is not a user on the entry\'s exchange' do
      exchange.entries.first.user = create :user
      expect( ability ).not_to be_able_to :create, new_entry
    end
  end

  context 'comments' do
    it { should be_able_to :create, Comment.new }
  end

  context 'taggings' do
    it 'is able to create one of its own taggings' do
      tagging = build :tagging, user: user
      expect( ability ).to be_able_to :create, tagging
    end

    it 'is not able to create a tagging for another user' do
      other_user = create :user
      tagging = build :tagging, user: other_user
      expect( ability ).not_to be_able_to :create, tagging
    end

    it 'is able to delete one of its own taggings' do
      tagging = create :tagging, user: user
      expect( ability ).to be_able_to :destroy, tagging
    end

    it 'is not able to delete a tagging of another user' do
      other_user = create :user
      tagging = create :tagging, user: other_user
      expect( ability ).not_to be_able_to :destroy, tagging
    end
  end
end
