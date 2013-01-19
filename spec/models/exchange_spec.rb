require 'spec_helper'

describe Exchange do
  subject { build :exchange }

  it "creates a new instance given valid attributes" do
    expect( subject ).to be_valid
  end

  it 'contains entries' do
    subject.entries << build_list( :entry, 11 )
    subject.save!
    expect( subject.reload.entries.length ).to eq 11
  end

  it 'contains taggings' do
    subject.save!
    subject.taggings << create_list( :tagging, 9 )
    expect( subject.reload.taggings.length ).to eq 9
  end

  context 'ordered_user_ids' do
    before :each do
      subject.entries << build( :entry, user: create( :user, id: 123, username: 'one' ), created_at: 1.day.ago )
      subject.entries << build( :entry, user: create( :user, id: 345, username: 'two' ), created_at: 2.days.ago )
    end

    it 'populates its ordered_user_ids based on the entries' do
      expect( subject.ordered_user_ids ).to eq [345,123]
    end
    
    it 'returns unique ordered_user_ids' do
      subject.entries << build( :entry, user: create( :user, id: 123 ), created_at: 1.day.since )
      expect( subject.ordered_user_ids ).to eq [345,123]
    end

    it 'does not break if entries do not yet have a created_at value' do
      subject.entries.build
      expect( subject.ordered_user_ids ).to eq [345,123]
    end

    it 'only allows two users' do
      subject.entries << build( :entry, user: create( :user, id: 678 ), created_at: 1.day.ago )
      expect( subject.ordered_user_ids ).to eq [345,123]
    end

    it 'does not include entries that has not yet been saved' do
      subject.entries.destroy_all
      subject.entries.build( user: create( :user ) )
      expect( subject.ordered_user_ids ).to eq []
    end

    it 'returns ordered usernames' do
      expect( subject.ordered_usernames ).to eq ['two', 'one']
    end
  end

  context 'parent' do
    let( :parent_exchange ) { create :exchange, entries: [parent_entry] }
    let( :parent_entry ) { create :entry, comments: [parent_comment] }
    let( :parent_comment ) { create :comment, content: 'comment content' }

    before :each do
      subject.parent_exchange_id = parent_exchange.id
      subject.parent_entry_id = parent_entry.id
      subject.parent_comment_id = parent_comment.id
    end

    specify { expect( subject.parent_exchange ).to eq parent_exchange }
    specify { expect( subject.parent_entry ).to eq parent_entry }
    specify { expect( subject.parent_comment ).to eq parent_comment }
  end

  context 'initial values' do
    let( :parent_exchange ) { create :exchange_with_entry_and_comment }
    let( :parent_entry ) { parent_exchange.entries.first }
    let( :parent_comment ) { parent_entry.comments.first }
    let( :commenter ) { build :user }
    let( :user ) { mock_model User }
    let( :initial_values ) { { parent_exchange_id: parent_exchange.id.to_s, parent_entry_id: parent_entry.id.to_s, parent_comment_id: parent_comment.id.to_s, content: 'good exchange', user_id: user.id } }
    let( :exchange ) { Exchange.new_with_initial_values initial_values }

    describe 'when the comment, entry and exchange ids match up' do
      before :each do
        parent_comment.content = 'comment content'
        parent_comment.user = commenter
        parent_comment.save!
      end

      context 'setting parents' do
        specify { expect( exchange.parent_exchange ).to eq parent_exchange }
        specify { expect( exchange.parent_entry ).to eq parent_entry }
        specify { expect( exchange.parent_comment ).to eq parent_comment }
      end

      context 'converting passed strings to BSON' do
        specify { expect( exchange.parent_exchange_id.class ).to eq Moped::BSON::ObjectId }
        specify { expect( exchange.parent_entry_id.class ).to eq Moped::BSON::ObjectId }
        specify { expect( exchange.parent_comment_id.class ).to eq Moped::BSON::ObjectId }
      end
      
      context 'initial entry' do
        let( :first_entry ) { exchange.entries.first }

        it 'has content matching the parent comment\'s content' do
          expect( first_entry.content ).to eq 'comment content'
        end

        it 'has a user id matching the parent comment\'s user id' do
          expect( first_entry.user_id ).to eq commenter.id
        end
      end

      context 'initial response' do
        let( :second_entry ) { exchange.entries[1] }

        it 'is assigned the passed in content' do
          expect( second_entry.content ).to eq 'good exchange'
        end

        it 'assigns the user' do
          expect( second_entry.user_id ).to eq user.id
        end
      end
    end
  end

  it 'cascades callbacks' do
    subject.entries = [build( :entry ), build( :entry )]
    subject.save!
    subject.entries.each { |entry| expect( entry.created_at ).not_to be_nil }
  end

  it 'returns exchange tags' do
    exchange_tags = double
    ExchangeTag.stub( :find_by_exchange ).with( subject ) { exchange_tags }
    expect( subject.exchange_tags ).to eq exchange_tags
  end
end
