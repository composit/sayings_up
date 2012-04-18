require 'spec_helper'

describe Comment do
  it 'is valid' do
    FactoryGirl.build( :comment ).should be_valid
  end

  it 'only includes the id and content in the json' do
    subject.to_json.should =~ /{\"_id\":\"\w+\",\"content\":null}/
  end

  it 'returns the entry\'s user_id' do
    user = FactoryGirl.create :user
    subject.entry = FactoryGirl.build :entry, user: user
    subject.entry_user_id.should == user.id
  end

  it "requires the existence of a user" do
    pending
    comment = FactoryGirl.build( :entry, :user_id => nil )
    comment.should_not be_valid
    comment.errors[:user_id].length.should eql( 1 )
    comment.errors[:user_id].should include( "can't be blank" )
  end

  it "creates a new exchange with two entries and users" do
    pending
    user_1 = FactoryGirl( :user, :username => "User first" )
    user_2 = FactoryGirl( :user, :username => "User second" )
    top_exchange = FactoryGirl( :exchange )
    top_entry = FactoryGirl.build( :entry, :content => "entry content", :user_id => user_1.id, :exchange => top_exchange )
    top_comment = FactoryGirl( :comment, :content => "comment content", :user_id => user_2.id, :entry => top_entry )
    exchange = top_comment.new_exchange
    exchange.users.should eql( [ user_1, user_2 ] )
    exchange.entries.collect { |entry| entry.content }.should eql( [ "entry content", "comment content" ] )
    exchange.parent_exchange.should eql( top_exchange )
    exchange.parent_entry_id.should eql( top_entry.id )
    exchange.parent_comment_id.should eql( top_comment.id )
  end

  it "creates a new exchange with entry timestamps that match the original entries" do
    pending
    entry = FactoryGirl.build( :entry )
    comment = FactoryGirl( :comment, :entry => entry )
    exchange = comment.new_exchange
    exchange.entries.all[0].created_at.should eql( entry.created_at )
    exchange.entries.all[1].created_at.should eql( comment.created_at )
  end

  it "recognizes child exchanges" do
    pending
    entry = FactoryGirl.build( :entry )
    comment = FactoryGirl( :comment, :entry => entry )
    exchange = comment.new_exchange
    exchange.save!
    comment.child_exchange.should eql( exchange )
  end
end
