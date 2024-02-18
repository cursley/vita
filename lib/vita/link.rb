module Vita
  class Link < Struct.new(:from_note, :to_note, :text, :context, :context_position)
    def highlights
      [
        Highlight.new(context[0, context_position], false),
        Highlight.new(context[context_position, text.length], true),
        Highlight.new(context[(context_position + text.length)..], false)
      ].reject(&:empty?)
    end
  end

  class Highlight < Struct.new(:text, :match?)
    def to_s
      text
    end

    def empty?
      text.empty?
    end
  end
end
