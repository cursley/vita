require "cgi"

module Vita
  module Html
    def link_to(text, href)
      "<a href=\"#{h(href)}\">#{h(text)}</a>"
    end

    def h(text)
      if text
        CGI.escape_html(text.to_s)
      else
        ""
      end
    end
  end
end
