require "spec_helper"
require "vita/note"

module Vita
  describe Note do
    subject(:note) { Note.new("path/to/Note.txt") }

    before do
      allow(File).to receive(:read).with(note.filename).and_return("Content")
    end

    it "has a file name" do
      expect(note.filename).to eq "path/to/Note.txt"
    end

    it "has a title" do
      expect(note.title).to eq "Note"
    end

    it "reads content from file" do
      expect(note.content).to eq "Content"
    end
  end
end
