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

    # Get this note's primary title.
    def title
      @note.title
    end

    # Get alternative names for this note.
    def synonyms
      if @note.content.start_with? "Synonyms:"
        @note.content[9..@note.content.index("\n")].split(",").map(&:strip)
      else
        []
      end
    end

    # Get all names for this note, including its title and synonyms.
    def all_names
      [title, *synonyms]
    end

    # Get a regular expression that matches any of this note's names surrounded
    # by word boundaries.
    def names_regexp
      elements = all_names.map { |name| /#{Regexp.quote(name)}/i }
      /\b#{Regexp.union(elements)}\b/
    end

    def path
      if home?
        "index.html"
      else
        @note.title.downcase.gsub(/\s+/, "-") + ".html"
      end
    end

    def content
      if @note.content.start_with? "Synonyms:"
        @note.content[@note.content.index("\n") + 1..]
      else
        @note.content
      end
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
      regexp = Regexp.union(notes.map(&:names_regexp))
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
