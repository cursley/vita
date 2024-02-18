require "vita/format/markdown"
require "vita/format/org"

module Vita
  module Format
    def self.for_filename(filename)
      case File.extname(filename.downcase)
      when ".org"
        Format::Org.instance
      else
        Format::Markdown.instance
      end
    end
  end
end
