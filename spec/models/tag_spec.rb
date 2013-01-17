require 'spec_helper'

describe Tag do
  subject { build :tag }

  it 'has a name' do
    subject.name = 'test'
    subject.save!
    expect( subject.reload.name ).to eq 'test'
  end

  it 'has many taggings' do
    subject.save!
    create_list :tagging, 11, tag: subject
    expect( subject.reload.taggings.length ).to eq 11
  end
end
