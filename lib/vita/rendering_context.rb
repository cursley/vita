require "vita/html"

module Vita
  class RenderingContext
    include Html

    attr_reader :note

    def initialize(note)
      @note = note
    end

    def garden
      note.garden
    end

    def content_html
      note.outlinks.reduce(note.html) { |html, link|
        html.sub(
          /(?<=\s)#{Regexp.quote(link.text)}\b/,
          link_to(link.text, link.to_note.path)
        )
      }
    end

    def link_to_note(note)
      link_to note.title, note.path
    end

    def get_binding
      binding
    end
  end
end
