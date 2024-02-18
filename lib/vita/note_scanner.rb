module Vita
  class NoteScanner
    CONTEXT_BOUNDARY = /(?<=\A|[.!?])|\n\n|\z/
    NOT_WHITESPACE = /\S/

    Match = Struct.new(:position, :text, :context, :context_position)

    attr_reader :string

    def initialize(string)
      @string = string
    end

    def scan(regexp)
      matches = string.to_enum(:scan, regexp).map { Regexp.last_match }

      matches.map do |match|
        link_text = match[0]
        match_start, match_end = match.offset(0)

        prev_context_boundary = string.rindex(CONTEXT_BOUNDARY, match_start)
        next_context_boundary = string.index(CONTEXT_BOUNDARY, match_end)

        context_start = string.index(NOT_WHITESPACE, prev_context_boundary)
        context_end = string.rindex(NOT_WHITESPACE, next_context_boundary)

        context_around_match = string[context_start..context_end]

        Match.new(
          position: match_start,
          text: link_text,
          context: flatten_newlines(context_around_match),
          context_position: match_start - context_start
        )
      end
    end

    def flatten_newlines(string)
      string.tr("\n", " ")
    end
  end
end
