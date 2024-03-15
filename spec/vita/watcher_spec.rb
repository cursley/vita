require "spec_helper"
require "vita/watcher"

module Vita
  describe Watcher do
    let(:garden) { instance_double("Garden", note_filename_pattern: "pattern") }
    subject(:watcher) { Watcher.new(garden) }

    it "uses filewatcher to watch files" do
      filewatcher = instance_double("Filewatcher")
      expect(filewatcher).to receive(:watch).and_return(nil)
      expect(Filewatcher).to receive(:new).with(garden.note_filename_pattern).and_return(filewatcher)

      watcher.watch {}
    end
  end
end
