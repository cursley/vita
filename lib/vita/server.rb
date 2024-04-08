require "sinatra"
require "sinatra/streaming"

module Vita
  class Server < Sinatra::Base
    helpers Sinatra::Streaming

    def self.await_startup
      sleep 0.1 until settings.running?
    end

    configure do
      enable :quiet
      set :port, 9000
    end

    before do
      garden.update!
    end

    get "/" do
      note = garden.notes.first

      if note
        redirect to note.path
      else
        status 404
      end
    end

    get "/events", provides: "text/event-stream" do
      stream do |out|
        Watcher.new(garden).watch do
          out << "event: change\ndata: {}\n\n"
        end
      end
    end

    get "/:path.html" do |path|
      note = garden.note_at_path("#{path}.html")

      if note
        renderer.render_html(note)
      else
        status 404
      end
    end

    private

    def garden
      settings.garden
    end

    def renderer
      Renderer.new(garden)
    end
  end
end
