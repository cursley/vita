require "singleton"
require "redcarpet"

module Vita
  module Format
    class Markdown
      include Singleton
      def initialize
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
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
