require "spec_helper"
require "vita/note_scanner"

module Vita
  describe NoteScanner do
    it "scans a string for a regular expression and returns all matches and context" do
      result = NoteScanner.new("This is a string. The string contains two sentences.").scan("string")

      expect(result).to have(2).items

      first, second = result

      expect(first.position).to eq 10
      expect(first.text).to eq "string"
      expect(first.context).to eq "This is a string."
      expect(first.context_position).to eq 10

      expect(second.position).to eq 22
      expect(second.text).to eq "string"
      expect(second.context).to eq "The string contains two sentences."
      expect(second.context_position).to eq 4
    end

    it "uses the whole string for context" do
      result = NoteScanner.new("This short string contains no context boundaries").scan("string")

      expect(result).to have(1).item

      expect(result[0].context).to eq "This short string contains no context boundaries"
    end

    it "removes line breaks when creating context" do
      result = NoteScanner.new("This string contains one text fragment\ndivided over two lines").scan("string")

      expect(result).to have(1).item

      expect(result[0].context).to eq "This string contains one text fragment divided over two lines"
    end

    it "uses empty lines as context boundaries" do
      result = NoteScanner.new("This string contains two text fragments separated by a blank line\n\nThe blank line should act as a boundary between the fragments").scan("fragments")

      expect(result).to have(2).items

      first, second = result
      expect(first.context).to eq "This string contains two text fragments separated by a blank line"
      expect(second.context).to eq "The blank line should act as a boundary between the fragments"
    end
  end
end
