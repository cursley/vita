require "spec_helper"
require "vita/garden_note"

module Vita
  describe GardenNote do
    let(:note) {
      note_content = <<~TEXT
        This is the first note. Notes can refer to other notes. For example, this note
        refers to the second note.

        When a note's content includes the title of another note, a bidirectional link
        is created between the two notes. A note's links to other notes are called its
        outlinks, and a note's links from other notes are called backlinks.

        This note contains several outlinks to the second note. Outlinks are not
        case-sensitive: Second Note creates an outlink too.
      TEXT

      instance_double("Note",
        title: "First note",
        filename: "First note.txt",
        content: note_content,
        html: "HTML")
    }

    let(:garden) { instance_double("Garden", home_note: nil) }
    subject(:garden_first_note) { GardenNote.new(garden, note) }

    it "has a title" do
      expect(subject.title).to eq note.title
    end

    it "has a regular expression that matches the title" do
      expect(subject.names_regexp).to match("Content that mentions first note")
      expect(subject.names_regexp).to_not match("First noteful")
      expect(subject.names_regexp).to_not match("No match here")
    end

    it "has content from the note" do
      expect(subject.content).to eq note.content
    end

    it "formats HTML" do
      format_double = double(to_html: "HTML")
      expect(Format).to receive(:for_filename).with("First note.txt").and_return(format_double)

      expect(subject.html).to eq "HTML"
    end

    it "has a path based on the note title" do
      expect(subject.path).to eq "first-note.html"
    end

    context "with synonyms" do
      let(:note) {
        note_content = <<~TEXT
          Synonyms: one, two , fourty seven
          This is the content.
        TEXT
        instance_double("Note",
          title: "Note",
          filename: "Note.txt",
          content: note_content,
          html: "HTML")
      }

      it "has synonyms" do
        expect(subject.synonyms).to eq ["one", "two", "fourty seven"]
      end

      it "has a regexp that matches the note title and synonyms" do
        expect(subject.names_regexp).to match("note")
        expect(subject.names_regexp).to match("one")
        expect(subject.names_regexp).to match("two")
        expect(subject.names_regexp).to match("fourty seven")
      end

      it "does not include the synonym list in the content" do
        expect(subject.content).to eq "This is the content.\n"
      end
    end

    context "with content longer than the excerpt length" do
      it "has an excerpt truncated to the excerpt length" do
        expect(subject.excerpt.length).to eq 161
        expect(subject.excerpt).to eq "This is the first note. Notes can refer to other notes. For example, this note\nrefers to the second note.\n\nWhen a note's content includes the title of another n…"
      end
    end

    context "with content less than the excerpt length" do
      let(:note) {
        instance_double("Note",
          title: "Short note",
          content: "This note's content fits within the excerpt length, so this note's excerpt includes all of its content.")
      }

      it "includes the full content in the excerpt" do
        expect(subject.excerpt).to eq subject.content
      end
    end

    context "home note" do
      before do
        allow(garden).to receive(:home_note).and_return(garden_first_note)
      end

      it "is the home note" do
        expect(subject).to be_home
      end

      it "has path of index.html" do
        expect(subject.path).to eq "index.html"
      end
    end

    context "in a garden with one note" do
      before do
        allow(garden).to receive(:linkable_notes).and_return([garden_first_note])
        allow(garden).to receive(:links_to).and_return([])
      end

      it "has no outlinks" do
        expect(subject.outlinks).to be_empty
      end

      it "has no backlinks" do
        expect(subject.backlinks).to be_empty
      end

      it "has no links" do
        expect(subject.links).to be_empty
      end
    end

    context "in a garden with two notes" do
      let(:second_note) {
        instance_double("Note", title: "Second note", content: "")
      }
      let(:garden_second_note) { GardenNote.new(garden, second_note) }

      before do
        allow(garden).to receive(:linkable_notes).and_return([garden_first_note, garden_second_note])
        allow(garden).to receive(:[]).with("second note").and_return(garden_second_note)
        allow(garden).to receive(:[]).with("Second Note").and_return(garden_second_note)
      end

      it "has links to another note (outlinks)" do
        expect(garden_first_note).to have(3).outlinks

        first, second, third = garden_first_note.outlinks

        expect(first.from_note).to eq garden_first_note
        expect(first.to_note).to eq garden_second_note
        expect(first.text).to eq "second note"
        expect(first.context).to eq "For example, this note refers to the second note."

        expect(second.from_note).to eq garden_first_note
        expect(second.to_note).to eq garden_second_note
        expect(second.text).to eq "second note"
        expect(second.context).to eq "This note contains several outlinks to the second note."

        expect(third.from_note).to eq garden_first_note
        expect(third.to_note).to eq garden_second_note
        expect(third.text).to eq "Second Note"
        expect(third.context).to eq "Outlinks are not case-sensitive: Second Note creates an outlink too."
      end

      it "has a link from another note (backlink)" do
        backlink = instance_double("Link")
        allow(garden).to receive(:links_to).with(subject).and_return([backlink])

        expect(subject).to have(1).backlinks
        expect(subject.backlinks[0]).to be backlink
      end
    end
  end
end
