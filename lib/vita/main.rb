require "launchy"
require "fileutils"
require "vita/server"

module Vita
  class Main
    attr_reader :garden

    def initialize(garden, stdout)
      @garden = garden
      @stdout = stdout
    end

    def call(*args)
      if garden.empty?
        puts "Your garden is empty. Create a text file in this directory first."
        return 1
      end

      case args.first
      when "open", nil
        start_server
        open_browser
        0
      when "serve"
        start_server
        0
      when "publish"
        publish
        0
      else
        puts "Usage: vita [open|serve|publish]"
        1
      end
    end

    def join
      @server_thread&.join
    end

    def stop_server
      @server_thread&.kill
    end

    private

    def publish
      renderer = Renderer.new(garden)

      FileUtils.remove_dir(publish_directory, force: true)
      Dir.mkdir(publish_directory)
      garden.notes.each do |note|
        File.write(
          File.join(publish_directory, note.path),
          renderer.render_html(note)
        )
        puts "#{note.title} (#{note.path})"
      end
    end

    def start_server
      puts Vita::BANNER
      puts "Starting Vita #{Vita::VERSION} at #{server_url}"
      Server.set(:garden, garden)
      @server_thread = Thread.new do
        Server.run!
      end
    end

    def open_browser
      Server.await_startup
      Launchy.open(server_url)
    end

    def server_url
      "http://localhost:9000"
    end

    def publish_directory
      File.join(garden.root, "publish")
    end

    def puts(s)
      @stdout.puts(s)
    end
  end
end
