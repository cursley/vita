require "erb"
require "vita/rendering_context"

module Vita
  class Renderer
    def render_html(note)
      context = RenderingContext.new(note)
      template.result(context.get_binding)
    end

    private

    def template
      @template ||= ERB.new(File.read(template_path))
    end

    def template_path
      File.join(Vita::BASE_DIRECTORY, "templates", "note.html.erb")
    end
  end
end
