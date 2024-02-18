require "vita/note"
require "vita/garden_note"
require "vita/error"

module Vita
  class Garden
    attr_reader :root, :title, :notes

    def self.read(root)
      new(root, Garden.get_notes(root))
    end

    def self.get_notes(root)
      unless File.directory? root
        raise Vita::Error.new("Directory not found at #{root}")
      end

      Dir[File.join(root, "*.*")].map { |filename| Note.new(filename) }
    end

    def initialize(root, notes)
      @root = File.expand_path(root)
      @title = File.basename(root)
      self.notes = notes
    end

    def update!
      self.notes = Garden.get_notes(root)
    end

    def empty?
      @notes.empty?
    end

    def [](title)
      @notes_hash[title.downcase]
    end

    def note_at_path(path)
      @notes.find { |note| note.path == path }
    end

    def linkable_notes
      @notes - [home_note]
    end

    def home_note
      self["home"]
    end

    def links
      notes.flat_map(&:outlinks)
    end

    def links_to(note)
      links.filter { |link| link.to_note == note }
    end

    private

    def notes=(notes)
      @notes = notes.map { |note| GardenNote.new(self, note) }.sort_by(&:title)
      @notes_hash = @notes.map { |note| [note.title.downcase, note] }.to_h

      if home_note
        @notes.delete(home_note)
        @notes.insert(0, home_note)
      end
    end
  end
end
