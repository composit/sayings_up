require 'html_formatting'

shared_examples_for HtmlFormatting do
  it 'does not die when content is nil' do
    subject.content = nil
    expect( subject.html_content ).to eq ""
  end

  it 'displays scripts instead of executing them' do
    subject.content = "<script>alert('hello!');</script>"
    expect( subject.html_content ).to eq "&lt;script&gt;alert('hello!');&lt;/script&gt;"
  end

  it 'displays html tags' do
    subject.content = "<div>contents</div>"
    expect( subject.html_content ).to eq "<div>contents</div>"
  end

  it 'fixes up poor html formatting' do
    subject.content = "contents</div>"
    expect( subject.html_content ).to eq "<p>contents</p>"
  end

  it 'adds header tags' do
    subject.content = <<-END
#one
##two
END
    expect( subject.html_content ).to eq "<h1>one</h1>\n\n<h2>two</h2>"
  end

  it 'adds code blocks' do
    subject.content = <<-END
```
codez
```
END
    expect( subject.html_content ).to eq "<p><code>\ncodez\n</code></p>"
  end

  it 'displays link text' do
    subject.content = '[something](/otherwise/)'
    expect( subject.html_content ).to eq "<p><a href=\"/otherwise/\" rel=\"nofollow\">something</a></p>"
  end

  it 'autolinks unformatted links' do
    subject.content = 'go here: http://google.com'
    expect( subject.html_content ).to eq "<p>go here: <a href=\"http://google.com\" rel=\"nofollow\">http://google.com</a></p>"
  end

  it 'adds nofollow to links' do
    subject.content = '[something](/otherwise/)'
    expect( subject.html_content ).to eq "<p><a href=\"/otherwise/\" rel=\"nofollow\">something</a></p>"
  end

  it 'adds curly quotes' do
    subject.content = '"something..."'
    expect( subject.html_content ).to eq "<p>“something…”</p>"
  end
end
