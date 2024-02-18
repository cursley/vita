require "spec_helper"
require "vita/html"

module Vita
  describe Html do
    include Html

    describe "link_to" do
      it "outputs an anchor tag" do
        expect(link_to("Title", "href")).to eq "<a href=\"href\">Title</a>"
      end

      it "escapes its content" do
        expect(link_to("\"LASER\"", "->")).to eq "<a href=\"-&gt;\">&quot;LASER&quot;</a>"
      end
    end

    describe "h" do
      it "returns empty string when called with nil" do
        expect(h(nil)).to eq ""
      end

      it "escapes the string for HTML" do
        expect(h("<marquee>")).to eq "&lt;marquee&gt;"
      end
    end
  end
end
