require "singleton"
require "redcarpet"

module Vita
  module Format
    class Markdown
      include Singleton
      def initialize
        @markdown = Redcarpet::Markdown.new(
          Redcarpet::Render::HTML,
          fenced_code_blocks: true,
          highlight: true,
          space_after_headers: true,
          strikethrough: true
        )
      end

      def name
        "markdown"
      end

      def to_html(source)
        @markdown.render(source)
      end
    end
  end
end
