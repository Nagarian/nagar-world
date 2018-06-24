class YouTube < Liquid::Tag
  Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/

  def initialize(tagName, markup, tokens)
    super
  
    if markup =~ Syntax then
      @id = $1
    else
      raise "No YouTube ID provided in the \"youtube\" tag"
    end
  end

  def render(context)
    "<iframe width=\"100%\" height=\"400\" src=\"http://www.youtube.com/embed/#{@id}?color=white&theme=light\" frameborder=\"0\" allowfullscreen ></iframe>"
  end

  Liquid::Template.register_tag "youtube", self
end