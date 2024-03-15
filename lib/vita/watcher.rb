require "filewatcher"

module Vita
  class Watcher
    def initialize(garden)
      @garden = garden
    end

    def watch(&)
      Filewatcher.new(@garden.note_filename_pattern).watch(&)
    end
  end
end
