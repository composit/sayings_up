require 'spec_helper'

describe Entry do
  it 'creates a new instance given valid attributes' do
    FactoryGirl.build( :entry ).should be_valid
  end

  it 'only includes the id, comments and content attributes in the json' do
    subject.to_json.should =~ /^{\"_id\":\"\w+\",\"content\":null,\"user_id\":null,\"exchange_id\":null,\"comments\":\[\]}$/
  end

  it 'contains comments' do
    entry = FactoryGirl.build :entry
    entry.comments << FactoryGirl.build_list( :comment, 11 )
    entry.save!
    entry.reload.comments.length.should == 11
  end

  it 'belongs to a user' do
    user = User.new
    subject.user = user
    subject.user.should == user
  end

  it 'persists the user to the database' do
    user = FactoryGirl.create :user
    entry = FactoryGirl.build :entry
    entry.user = user
    entry.save!
    entry.reload.user.should == user
  end

  it 'returns the exchange id' do
    exchange = FactoryGirl.create :exchange
    entry = Entry.new
    exchange.entries << entry
    entry.exchange_id.should == exchange.id
  end

  it 'requires the existence of a user' do
    pending
    entry = FactoryGirl.build( :entry, :user_id => nil )
    entry.should_not be_valid
    entry.errors[:user_id].length.should eql( 1 )
    entry.errors[:user_id].should include( 'can\'t be blank' )
  end

  it 'does not comments if it is the initial entry in an exchange associated with a comment' do
    pending
    exchange = FactoryGirl( :exchange )
    first_entry = exchange.entries.build( :user_id => User.create.id, :created_at => '2001-01-01' )
    second_entry = exchange.entries.build( :user_id => User.create.id, :created_at => '2002-02-02' )
    first_entry.comments.build
    second_entry.comments.build
    first_entry.save
    first_entry.errors.length.should eql( 1 )
    first_entry.errors[:base].should include( 'Comments are not allowed for this record' )
    second_entry.save
    second_entry.errors.length.should eql( 0 )
  end
end
