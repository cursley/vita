require "singleton"
require "org-ruby"

module Vita
  module Format
    class Org
      include Singleton

      def name
        "org"
      end

      def to_html(source)
        Orgmode::Parser.new(source).to_html
      end
    end
  end
end
