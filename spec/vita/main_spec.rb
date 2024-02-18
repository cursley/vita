require "spec_helper"
require "vita"
require "vita/main"

module Vita
  describe Main do
    let(:output) { StringIO.new }
    subject(:main) { Main.new(garden, output) }

    before do
      allow(Server).to receive(:run!)
    end

    after do
      main.join
      output.close
    end

    def output_string
      output.rewind
      output.read
    end

    context "empty garden" do
      let(:garden) { instance_double("Garden", empty?: true) }

      it "outputs a message and returns 1" do
        expect(main.call).to eq 1

        expect(output_string).to eq "Your garden is empty. Create a text file in this directory first.\n"
      end
    end

    context "test garden" do
      let(:garden) { instance_double("Garden", empty?: false) }

      describe "serve" do
        it "starts the server" do
          expect(Server).to receive(:set).with(:garden, garden)
          expect(Server).to receive(:run!)

          main.call("serve")
        end
      end

      describe "open" do
        it "opens a web browser" do
          expect(Launchy).to receive(:open).with("http://localhost:9000")

          main.call("open")
        end
      end
    end
  end
end
