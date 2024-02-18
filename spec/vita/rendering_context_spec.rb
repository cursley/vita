require "spec_helper"
require "vita/rendering_context"

module Vita
  describe RenderingContext do
    subject { RenderingContext.new(note) }

    let(:link) {
      instance_double("Link",
        text: "note",
        to_note: instance_double("GardenNote", path: "note.html"))
    }

    let(:note) {
      instance_double("GardenNote",
        title: "Example note",
        path: "example-note.html",
        garden: instance_double("Garden"),
        html: "<p>This is the first note. Notes can refer to other notes. For example, this note refers to the second note.</p>",
        outlinks: [link, link, link])
    }

    it "gets the current note" do
      expect(subject.note).to be note
    end

    it "gets the garden" do
      expect(subject.garden).to be note.garden
    end

    it "renders an HTML link to a note" do
      expect(subject).to receive(:link_to).with(note.title, note.path)

      subject.link_to_note(note)
    end

    it "gets a binding" do
      expect(subject.get_binding).to be_a Binding
    end

    it "renders HTML content for the current note" do
      expect(subject.content_html).to eq "<p>This is the first <a href=\"note.html\">note</a>. Notes can refer to other notes. For example, this <a href=\"note.html\">note</a> refers to the second <a href=\"note.html\">note</a>.</p>"
    end
  end
end
