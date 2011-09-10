require 'spec_helper'

describe Exchange do
  it "creates a new instance given valid attributes" do
    pending
    Factory( :exchange ).should be_valid
  end

  it "adds users" do
    pending
    user_1 = Factory( :user )
    user_2 = Factory( :user )
    exchange = Factory( :exchange )
    exchange.users << user_1
    exchange.users << user_2
    exchange.save
    Exchange.find( exchange.id ).users.should eql( [user_1, user_2] )
  end

  it "removes users" do
    pending
    user_1 = Factory( :user )
    user_2 = Factory( :user )
    exchange = Factory( :exchange )
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
    user = Factory( :user )
    exchange = Factory( :exchange )
    exchange.users << user
    exchange.save
    exchange.update_attributes( :entries_attributes => [{ :content => "this is a test", :user_id => user.id }] )
    exchange.entries.length.should eql( 1 )
    exchange.entries.first.content.should eql( "this is a test" )
    exchange.entries.first.user_id.should eql( user.id )
  end

  it "sets the most recent entry date" do
    pending
    exchange = Factory( :exchange )
    entry = Factory( :entry, :created_at => "2005-05-05", :exchange => exchange )
    exchange.most_recent_entry_date.strftime( "%Y-%m-%d" ).should eql( "2005-05-05" )
  end

  it "does not override the most recent entry with older dates" do
    pending
    exchange = Factory( :exchange )
    Factory( :entry, :created_at => "2005-05-05", :exchange => exchange )
    Factory( :entry, :created_at => "2001-01-01", :exchange => exchange )
    exchange.most_recent_entry_date.strftime( "%Y-%m-%d" ).should eql( "2005-05-05" )
  end

  it "overrides the most recent entry with newer dates" do
    pending
    exchange = Factory( :exchange )
    Factory( :entry, :created_at => "2001-01-01", :exchange => exchange )
    Factory( :entry, :created_at => "2009-09-09", :exchange => exchange )
    exchange.most_recent_entry_date.strftime( "%Y-%m-%d" ).should eql( "2009-09-09" )
  end

  it "determines ordered entries" do
    pending
    exchange = Factory( :exchange )
    Factory( :entry, :created_at => "2001-01-01", :exchange => exchange )
    Factory( :entry, :created_at => "2009-09-09", :exchange => exchange )
    Factory( :entry, :created_at => "2005-05-05", :exchange => exchange )
    Factory( :entry, :created_at => "2007-07-07", :exchange => exchange )
    exchange.ordered_entries.collect { |entry| entry.created_at.strftime( "%Y-%m-%y" ) }.should eql( ["2001-01-01", "2005-05-05", "2007-07-07", "2009-09-09"] )
  end
end
