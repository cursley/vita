require "vita/link"
require "vita/note_scanner"

module Vita
  class GardenNote
    EXCERPT_LENGTH = 160

    attr_reader :garden

    def initialize(garden, note)
      @garden = garden
      @note = note
    end

    def title
      @note.title
    end

    def title_regexp
      /\b#{Regexp.quote(title)}\b/i
    end

    def path
      if home?
        "index.html"
      else
        @note.title.downcase.gsub(/\s+/, "-") + ".html"
      end
    end

    def content
      @note.content
    end

    def html
      Format.for_filename(@note.filename).to_html(content)
    end

    def excerpt
      excerpt = content[0, EXCERPT_LENGTH]
      excerpt += "…" if excerpt.length < content.length
      excerpt
    end

    def outlinks
      @outlinks ||= create_outlinks
    end

    def backlinks
      garden.links_to(self)
    end

    def links
      outlinks + backlinks
    end

    def home?
      garden.home_note == self
    end

    private

    def create_outlinks
      notes = garden.linkable_notes - [self]
      regexp = Regexp.union(notes.map(&:title_regexp))
      matches = NoteScanner.new(content).scan(regexp)

      matches.map do |match|
        Link.new(
          from_note: self,
          to_note: garden[match.text],
          text: match.text,
          context: match.context,
          context_position: match.context_position
        )
      end
    end
  end
end
