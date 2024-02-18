require "spec_helper"
require "vita/format"

module Vita
  describe Format do
    describe ".for_filename" do
      def format_name(filename)
        Format.for_filename(filename).name
      end

      it "provides Markdown format for text files" do
        expect(format_name("test.md")).to eq "markdown"
        expect(format_name("test.txt")).to eq "markdown"
        expect(format_name("test")).to eq "markdown"
      end

      it "provides Org mode format for org files" do
        expect(format_name("test.org")).to eq "org"
        expect(format_name("TEST.ORG")).to eq "org"
      end
    end
  end
end
