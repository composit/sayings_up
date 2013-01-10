module HtmlFormatting
  def html_content
    markdowner = Redcarpet::Markdown.new Redcarpet::Render::HTML, autolink: true
    formatted_content = markdowner.render content.to_s
    formatted_content = Redcarpet::Render::SmartyPants.render formatted_content
    Loofah.fragment( formatted_content ).scrub!( :escape ).scrub!( :nofollow ).to_html
  end
end
