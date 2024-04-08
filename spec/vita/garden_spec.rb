require "spec_helper"
require "vita/garden"

module Vita
  describe Garden do
    describe ".read" do
      it "raises an error if the directory does not exist" do
        expect {
          Garden.read("spec/test_data/Non-existent")
        }.to raise_error(Vita::Error)
      end

      it "initialises with an empty directory" do
        garden = Garden.read("spec/test_data/Empty")

        expect(garden.root).to eq File.expand_path("spec/test_data/Empty")
        expect(garden.title).to eq "Empty"
        expect(garden).to be_empty
      end

      it "initialises with a directory containing text files" do
        garden = Garden.read("spec/test_data/Notes")

        expect(garden.root).to eq File.expand_path("spec/test_data/Notes")
        expect(garden.title).to eq "Notes"
        expect(garden).to have(1).notes
        expect(garden.home_note.content).to include "Welcome to my digital garden."
      end

      it "initialises with a directory containing a template" do
        garden = Garden.read("spec/test_data/Template")

        expect(garden["note.html"]).to be_nil
        expect(garden).to have(1).notes
      end
    end

    context "with no notes" do
      subject(:garden) { Garden.new("Garden", []) }

      it "has a title" do
        expect(garden.title).to eq "Garden"
      end

      it "is empty" do
        expect(garden).to be_empty
      end
    end

    context "with one note" do
      let(:note) { instance_double("Note", title: "Title", content: "Synonyms: other") }
      subject(:garden) { Garden.new("Garden", [note]) }

      it "is not empty" do
        expect(garden).to_not be_empty
      end

      it "has one note" do
        expect(garden).to have(1).notes
      end

      it "gets a note by title case-insensitively" do
        expect(garden["Title"].title).to eq "Title"
        expect(garden["title"].title).to eq "Title"
      end

      it "gets a note by synonyms case-insensitively" do
        expect(garden["Other"].title).to eq "Title"
        expect(garden["other"].title).to eq "Title"
      end

      it "returns nil if the note does not exist" do
        expect(garden["Non-existent"]).to be_nil
      end
    end

    context "with two notes" do
      let(:note_1) { instance_double("Note", title: "Note 1", content: "Refers to note 2") }
      let(:note_2) { instance_double("Note", title: "Note 2", content: "Refers to note 1") }
      subject(:garden) { Garden.new("Garden", [note_1, note_2]) }

      it "gets links between notes" do
        expect(garden).to have(2).links

        link_1, link_2 = garden.links

        expect(link_1.from_note.title).to eq "Note 1"
        expect(link_1.to_note.title).to eq "Note 2"

        expect(link_2.from_note.title).to eq "Note 2"
        expect(link_2.to_note.title).to eq "Note 1"
      end
    end

    it "sorts notes alphabetically by title" do
      garden = Garden.new("Garden", [
        instance_double("Note", title: "Bravo", content: ""),
        instance_double("Note", title: "Charlie", content: ""),
        instance_double("Note", title: "Alpha", content: "")
      ])

      expect(garden.notes.map(&:title)).to eq ["Alpha", "Bravo", "Charlie"]
    end

    context "with a home note" do
      subject(:garden) {
        Garden.new("Garden", [
          instance_double("Note", title: "Foxtrot", content: ""),
          instance_double("Note", title: "Delta", content: ""),
          instance_double("Note", title: "Home", content: "Welcome"),
          instance_double("Note", title: "Echo", content: "")
        ])
      }

      it "gets the home note" do
        expect(garden.home_note.content).to eq "Welcome"
      end

      it "sorts the home note first" do
        expect(garden.notes.map(&:title)).to eq ["Home", "Delta", "Echo", "Foxtrot"]
      end

      it "excludes the home note from linkable notes" do
        expect(garden.linkable_notes).to_not include garden.home_note
      end
    end
  end
end
