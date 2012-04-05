require 'spec_helper'

describe Exchange do
  it "creates a new instance given valid attributes" do
    FactoryGirl.build( :exchange ).should be_valid
  end

  it "only includes the id, entries and user_id attributes in the json" do
    exchange = FactoryGirl.build( :exchange, :entries => [FactoryGirl.build( :entry )] )
    exchange.to_json.should =~ /^{\"_id\":\"\w+\",\"ordered_user_ids":\[\w+\],\"entries\":\[.+\]}$/
  end

  it 'contains entries' do
    exchange = FactoryGirl.build( :exchange )
    exchange.entries << FactoryGirl.build_list( :entry, 11 )
    exchange.save!
    exchange.reload.entries.length.should == 11
  end

  context 'ordered_user_ids' do
    let( :exchange ) { FactoryGirl.build( :exchange ) }

    before :each do
      exchange.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 123 ), created_at: 1.day.since )
      exchange.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 345 ), created_at: 1.day.ago )
      exchange.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 678 ), created_at: Time.zone.now )
    end

    it 'populates its ordered_user_ids based on the entries' do
      exchange.ordered_user_ids.should == [345,678,123]
    end
    
    it 'returns unique ordered_user_ids' do
      exchange.entries << FactoryGirl.build( :entry, user: FactoryGirl.create( :user, id: 123 ), created_at: 1.day.since )
      exchange.ordered_user_ids.should == [345,678,123]
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
