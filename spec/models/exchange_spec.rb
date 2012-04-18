require 'spec_helper'

describe Exchange do
  it "creates a new instance given valid attributes" do
    FactoryGirl.build( :exchange ).should be_valid
  end

  it "only includes the id, entries and user_id attributes in the json" do
    subject.to_json.should =~ /^{\"_id\":\"\w+\",\"ordered_user_ids":\[\],\"entries\":\[\]}$/
    #TODO test instances with entries/comments
  end

  it 'contains entries' do
    subject.entries << FactoryGirl.build_list( :entry, 11 )
    subject.save!
    subject.reload.entries.length.should == 11
  end

  context 'ordered_user_ids' do
    before :each do
      subject.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 123 ), created_at: 1.day.ago )
      subject.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 345 ), created_at: 2.days.ago )
    end

    it 'populates its ordered_user_ids based on the entries' do
      subject.ordered_user_ids.should == [345,123]
    end
    
    it 'returns unique ordered_user_ids' do
      subject.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 123 ), created_at: 1.day.since )
      subject.ordered_user_ids.should == [345,123]
    end

    it 'does not break if entries do not yet have a created_at value' do
      subject.entries.build
      subject.ordered_user_ids.should == [345,123]
    end

    it 'only allows two users' do
      subject.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 678 ), created_at: 1.day.ago )
      subject.ordered_user_ids.should == [345,123]
    end

    it 'does not include entries that has not yet been saved' do
      subject.entries.destroy_all
      subject.entries.build( user: FactoryGirl.create( :user ) )
      subject.ordered_user_ids.should == []
    end
  end

  context 'parent' do
    let( :parent_exchange ) { FactoryGirl.create( :exchange, entries: [parent_entry] ) }
    let( :parent_entry ) { FactoryGirl.create( :entry, comments: [parent_comment] ) }
    let( :parent_comment ) { FactoryGirl.create( :comment, content: 'comment content' ) }

    before :each do
      subject.parent_exchange_id = parent_exchange.id
      subject.parent_entry_id = parent_entry.id
      subject.parent_comment_id = parent_comment.id
    end
    
    specify { subject.parent_exchange.should == parent_exchange }
    specify { subject.parent_entry.should == parent_entry }
    specify { subject.parent_comment.should == parent_comment }
  end

  context 'initial values' do
    #TODO move all this logic into a factory
    describe 'when the comment, entry and exchange ids match up' do
      let( :parent_exchange ) { FactoryGirl.create :exchange, entries: [parent_entry] }
      let( :parent_entry ) { FactoryGirl.create :entry, comments: [parent_comment] }
      let( :parent_comment ) { FactoryGirl.create :comment, content: 'comment content', user_id: commenter.id }
      let( :commenter ) { mock_model User }
      let( :user ) { mock_model User }
      let( :initial_values ) { { parent_exchange_id: parent_exchange.id, parent_entry_id: parent_entry.id, parent_comment_id: parent_comment.id, content: 'good exchange', user_id: user.id } }

      context 'setting parents' do
        before :each do
          subject.initial_values = initial_values
        end

        specify { subject.parent_exchange_id.should == parent_exchange.id }
        specify { subject.parent_entry_id.should == parent_entry.id }
        specify { subject.parent_comment_id.should == parent_comment.id }
      end
      
      context 'initial entry' do
        after :each do
          subject.initial_values = initial_values
        end

        it 'bla' do
          subject.entries.should_receive( :<< ).with [{ content: 'comment content', user_id: commenter.id}, { content: 'good entry', user_id: user.id }]
        end

        #it 'has content matching the parent comment\'s content' do
        #  subject.entries.should_receive( :build ).ordered.with hash_including content: 'comment content'
        #end

        #it 'has a user id matching the parent comment\'s user id' do
        #  subject.entries.should_receive( :build ).with hash_including user_id: commenter.id
        #end
      end

      context 'initial response' do
        #after :each do
        #  subject.initial_values = initial_values
        #end

        #it 'is assigned the passed in content' do
        #  subject.entries.should_receive( :build ).ordered.with( hash_including content: 'good exchange' ).once
        #end
        #it 'is assigned the passed in user id'
      end
    end

    describe 'when the comment, entry and exchange ids do not match up' do
      it 'does not assign the parent_comment_id'
      it 'does not assign the parent_entry_id'
      it 'does not assign the parent_exchange_id'
      it 'does not build any entries'
    end
  end

  it "adds users" do
    pending
    user_1 = FactoryGirl( :user )
    user_2 = FactoryGirl( :user )
    exchange = FactoryGirl( :exchange )
    exchange.users << user_1
    exchange.users << user_2
    exchange.save
    Exchange.find( exchange.id ).users.should eql( [user_1, user_2] )
  end

  it "removes users" do
    pending
    user_1 = FactoryGirl( :user )
    user_2 = FactoryGirl( :user )
    exchange = FactoryGirl( :exchange )
    exchange.users << user_1
    exchange.users << user_2
    exchange.save
    exchange = Exchange.where( :_id => exchange.id ).first
    exchange.users.delete( user_1 )
    exchange.save
    Exchange.find( exchange.id ).users.should eql( [user_2] )
  end

  it "creates entries via nested attributes" do
    pending
    user = FactoryGirl( :user )
    exchange = FactoryGirl( :exchange )
    exchange.users << user
    exchange.save
    exchange.update_attributes( :entries_attributes => [{ :content => "this is a test", :user_id => user.id }] )
    exchange.entries.length.should eql( 1 )
    exchange.entries.first.content.should eql( "this is a test" )
    exchange.entries.first.user_id.should eql( user.id )
  end

  it "sets the most recent entry date" do
    pending
    exchange = FactoryGirl( :exchange )
    entry = FactoryGirl( :entry, :created_at => "2005-05-05", :exchange => exchange )
    exchange.most_recent_entry_date.strftime( "%Y-%m-%d" ).should eql( "2005-05-05" )
  end

  it "does not override the most recent entry with older dates" do
    pending
    exchange = FactoryGirl( :exchange )
    FactoryGirl( :entry, :created_at => "2005-05-05", :exchange => exchange )
    FactoryGirl( :entry, :created_at => "2001-01-01", :exchange => exchange )
    exchange.most_recent_entry_date.strftime( "%Y-%m-%d" ).should eql( "2005-05-05" )
  end

  it "overrides the most recent entry with newer dates" do
    pending
    exchange = FactoryGirl( :exchange )
    FactoryGirl( :entry, :created_at => "2001-01-01", :exchange => exchange )
    FactoryGirl( :entry, :created_at => "2009-09-09", :exchange => exchange )
    exchange.most_recent_entry_date.strftime( "%Y-%m-%d" ).should eql( "2009-09-09" )
  end

  it "determines ordered entries" do
    pending
    exchange = FactoryGirl( :exchange )
    FactoryGirl( :entry, :created_at => "2001-01-01", :exchange => exchange )
    FactoryGirl( :entry, :created_at => "2009-09-09", :exchange => exchange )
    FactoryGirl( :entry, :created_at => "2005-05-05", :exchange => exchange )
    FactoryGirl( :entry, :created_at => "2007-07-07", :exchange => exchange )
    exchange.ordered_entries.collect { |entry| entry.created_at.strftime( "%Y-%m-%y" ) }.should eql( ["2001-01-01", "2005-05-05", "2007-07-07", "2009-09-09"] )
  end
end
