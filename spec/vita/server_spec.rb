require "spec_helper"
require "vita"
require "vita/server"
require "rack/test"

module Vita
  describe Server do
    include Rack::Test::Methods

    subject(:app) { Server.new }

    before do
      Server.set(:garden, garden)

      expect(garden).to receive(:update!)
    end

    context "for an empty garden" do
      let(:garden) { instance_double("Garden", notes: [], note_at_path: nil) }

      it "returns 404 for the root URL" do
        expect(get("/").status).to eq 404
      end

      it "returns 404 for a note URL" do
        expect(get("/note.html").status).to eq 404
      end
    end

    context "for a garden with a note" do
      let(:note) { instance_double("GardenNote", path: "note.html") }

      let(:garden) { instance_double("Garden", notes: [note], note_at_path: nil) }

      it "redirects from the root URL to the first note" do
        response = get("http://localhost:9000/")

        expect(response.status).to eq 302
        expect(response["Location"]).to eq "http://localhost:9000/note.html"
      end

      it "uses Renderer to render a note" do
        allow(garden).to receive(:note_at_path).with("note.html").and_return(note)
        renderer_double = instance_double("Renderer", render_html: "HTML")
        expect(Renderer).to receive(:new).and_return(renderer_double)

        response = get("/note.html")

        expect(response.status).to eq 200
        expect(response.body).to eq "HTML"
      end

      it "returns 404 for a note that does not exist" do
        expect(get("/example.html").status).to eq 404
      end
    end
  end
end
