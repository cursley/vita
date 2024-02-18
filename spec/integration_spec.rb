require "vita"
require "fileutils"
require_relative "integration_spec_helper"

describe "Vita" do
  include IntegrationSpecHelper

  let(:garden) { Vita::Garden.read(garden_path) }
  let(:publish_path) { "#{garden_path}/publish" }

  def remove_publish_directory
    FileUtils.remove_dir(publish_path, force: true)
  end

  context "with empty garden" do
    let(:garden_path) { "spec/test_data/Empty" }

    it "prints a message and exits" do
      stdout, status = run_vita

      expect(stdout).to include "Your garden is empty."
      expect(status.exitstatus).to eq 1
    end
  end

  context "with test garden" do
    let(:garden_path) { "spec/test_data/Notes" }

    describe "publish" do
      before { remove_publish_directory }
      after { remove_publish_directory }

      it "creates HTML files in the publish directory" do
        stdout, status = run_vita("publish")

        expect(stdout).to include "Home (index.html)"
        expect(status).to be_success

        index_html = File.read(File.join(garden_path, "publish", "index.html"))
        expect(index_html).to include garden.home_note.html
      end

      it "removes extra files in the publish directory" do
        Dir.mkdir(publish_path)
        File.write(File.join(publish_path, "file"), "")

        _, status = run_vita("publish")

        expect(status).to be_success

        expect(File.exist?(File.join(publish_path, "file"))).to be false
      end
    end

    describe "serve" do
      before { start_vita "serve" }
      after { stop_vita }

      after do
        filename = File.join(garden_path, "New.txt")
        File.delete(filename) if File.exist? filename
      end

      it "starts a web server" do
        response = http_get "http://localhost:9000/index.html"

        expect(response.code).to eq "200"
        expect(response.body).to include garden.home_note.html
      end

      it "renders a note created after the server started" do
        File.write(File.join(garden_path, "New.txt"), "This is a new file")

        response = http_get "http://localhost:9000/new.html"

        expect(response.code).to eq "200"
        expect(response.body).to include "This is a new file"
      end
    end
  end
end
