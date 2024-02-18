module Vita
  class Note
    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def title
      File.basename(@filename, File.extname(@filename))
    end

    def content
      @content ||= File.read(@filename)
    end
  end
end
