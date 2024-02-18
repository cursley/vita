require "spec_helper"
require "vita"

module Vita
  describe Renderer do
    subject(:renderer) { Renderer.new }

    it "invokes an ERB template with the binding from a RenderingContext" do
      context_binding = double
      context = double(get_binding: context_binding)
      allow(RenderingContext).to receive(:new).and_return(context)

      template = double
      expect(template).to receive(:result).with(context_binding).and_return("Result")

      allow(ERB).to receive(:new).and_return(template)

      expect(renderer.render_html(instance_double("GardenNote"))).to eq "Result"
    end
  end
end
