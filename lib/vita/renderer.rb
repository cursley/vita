require "erb"
require "vita/rendering_context"

module Vita
  class Renderer
    def initialize(garden)
      @garden = garden
    end

    def render_html(note)
      context = RenderingContext.new(note)
      template.result(context.get_binding)
    end

    private

    def template
      @template ||= ERB.new(File.read(template_path))
    end

    def template_path
      garden_template_path || default_template_path
    end

    def garden_template_path
      path = File.join(@garden.root, "note.html.erb")

      path if File.exist? path
    end

    def default_template_path
      File.join(Vita::BASE_DIRECTORY, "templates", "note.html.erb")
    end
  end
end
