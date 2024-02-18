require "spec_helper"
require "vita/link"

module Vita
  describe Link do
    subject(:link) {
      Link.new(
        from_note: double,
        to_note: double,
        text: "note",
        context: "Linking allows one note to be connected to another.",
        context_position: 19
      )
    }

    it "gets highlights" do
      expect(link).to have(3).highlights

      highlights = link.highlights

      expect(highlights[0].text).to eq "Linking allows one "
      expect(highlights[0]).to_not be_match
      expect(highlights[1].text).to eq "note"
      expect(highlights[1]).to be_match
      expect(highlights[2].text).to eq " to be connected to another."
      expect(highlights[2]).to_not be_match
    end
  end
end
