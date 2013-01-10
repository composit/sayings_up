require 'spec_helper'

describe Entry do
  it 'creates a new instance given valid attributes' do
    expect( build :entry ).to be_valid
  end

  it 'contains comments' do
    entry = build :entry
    entry.comments << build_list( :comment, 11 )
    entry.save!
    expect( entry.reload.comments.length ).to eq 11
  end

  it 'belongs to a user' do
    user = User.new
    subject.user = user
    expect( subject.user ).to eq user
  end

  it 'persists the user to the database' do
    user = create :user
    entry = build :entry
    entry.user = user
    entry.save!
    expect( entry.reload.user ).to eq user
  end

  it 'returns the exchange id' do
    exchange = create :exchange
    entry = Entry.new
    exchange.entries << entry
    expect( entry.exchange_id ).to eq exchange.id
  end

  it 'requires the existence of a user' do
    entry = build :entry, user: nil
    expect( entry ).not_to be_valid
    expect( entry.errors[:user].length ).to eq 1
    expect( entry.errors[:user] ).to include( 'can\'t be blank' )
  end

  it 'returns the user\'s username' do
    entry = build :entry, user: build( :user, username: 'testuser' )
    expect( entry.username ).to eq 'testuser'
  end

  it 'does not return the user\'s username if there is no user' do
    entry = build :entry, user: nil
    expect( entry.username ).to be_nil
  end

  describe 'html formatting' do
    it 'does not die when content is nil' do
      entry = build :entry, content: nil
      expect( entry.html_content ).to eq ""
    end

    it 'displays scripts instead of executing them' do
      entry = build :entry, content: "<script>alert('hello!');</script>"
      expect( entry.html_content ).to eq "&lt;script&gt;alert('hello!');&lt;/script&gt;"
    end

    it 'displays html tags' do
      entry = build :entry, content: "<div>contents</div>"
      expect( entry.html_content ).to eq "<div>contents</div>"
    end

    it 'fixes up poor html formatting' do
      entry = build :entry, content: "contents</div>"
      expect( entry.html_content ).to eq "<p>contents</p>"
    end

    it 'adds header tags' do
      entry = build :entry, content: <<-END
#one
##two
END
      expect( entry.html_content ).to eq "<h1>one</h1>\n\n<h2>two</h2>"
    end

    it 'adds code blocks' do
      entry = build :entry, content: <<-END
```
codez
```
END
      expect( entry.html_content ).to eq "<p><code>\ncodez\n</code></p>"
    end

    it 'displays link text' do
      entry = build :entry, content: '[something](/otherwise/)'
      expect( entry.html_content ).to eq "<p><a href=\"/otherwise/\" rel=\"nofollow\">something</a></p>"
    end

    it 'autolinks unformatted links' do
      entry = build :entry, content: 'go here: http://google.com'
      expect( entry.html_content ).to eq "<p>go here: <a href=\"http://google.com\" rel=\"nofollow\">http://google.com</a></p>"
    end

    it 'adds nofollow to links' do
      entry = build :entry, content: '[something](/otherwise/)'
      expect( entry.html_content ).to eq "<p><a href=\"/otherwise/\" rel=\"nofollow\">something</a></p>"
    end

    it 'adds curly quotes' do
      entry = build :entry, content: '"something..."'
      expect( entry.html_content ).to eq "<p>&#8220;something&#8230;&#8221;</p>"
    end
  end
end
