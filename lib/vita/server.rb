require "sinatra"

module Vita
  class Server < Sinatra::Base
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
      @renderer ||= Vita::Renderer.new
    end
  end
end
