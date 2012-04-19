require 'spec_helper'

describe CommentsController do
  context 'POST' do
    let( :current_user ) { stub }
    let( :comment ) { mock_model( Comment ).as_null_object }
    let( :comments ) { stub( new: comment ) }
    let( :entry ) { mock_model Entry, comments: comments }
    let( :entries ) { stub }
    let( :exchange ) { mock_model( Exchange, entries: entries ).as_null_object }
    let( :ability ) { Object.new }
    let( :params ) { { exchange_id: 123, entry_id: 456, comment: {}, format: :json } }

    before :each do
      @controller.stub( :current_user ) { current_user }
      ability.extend CanCan::Ability
      @controller.stub( :current_ability ) { ability }
      ability.can :read, Exchange
      ability.can :read, Entry
      ability.can :create, Comment
      Exchange.stub( :find ).with( '123' ) { exchange }
      entries.stub( :find ).with( '456' ) { entry }
    end

    after :each do
      post :create, params
    end

    it 'finds the appropriate exchange' do
      Exchange.should_receive( :find ).with '123'
    end

    it 'finds the appropriate entry' do
      entries.should_receive( :find ).with '456'
    end

    it 'assigns the current user' do
      comment.should_receive( :user= ).with current_user
    end

    it 'saves the comment' do
      exchange.should_receive :save
    end
  end
end
