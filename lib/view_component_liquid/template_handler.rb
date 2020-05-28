# frozen_string_literal: true

# Hook into ActiveView's template handling system
module ViewComponentLiquid
  class TemplateHandler
    class << self
      def call(template, source)
        "ViewComponentLiquid::TemplateHandler.new(self).render(#{source.inspect}, local_assigns)"
      end
    end

    def initialize(view)
      @view = view
      @controller = @view.controller
    end

    def render(template, local_assigns={})
      component = LiquidComponent.parse(template)
      template = component.content

      assigns = local_assigns.deep_stringify_keys
      assigns["component"] = component.to_h.deep_stringify_keys
      assigns["controller"] = {
        "controller_name" => @controller.controller_name,
        "action_name" => @controller.action_name
      }
      if @view.respond_to?(:assigns)
        assigns["controller"].merge! @view.assigns.to_h
        @view.instance_variable_set(:@liquid_page, component)
      end

      p "ASSIGNS", assigns

      liquid = Liquid::Template.parse(template)
      liquid.send(render_method, assigns, filters: filters, registers: registers).html_safe
    end

    def filters
      if @view.respond_to?(:liquid_filters, true)
        @view.send(:liquid_filters)
      end
    end

    def registers
      {
        view: @view,
        file_system: ViewComponentLiquid::FileSystem.new(@view)
      }
    end

    def compilable?
      false
    end

    def render_method
      (Rails.env.development? || Rails.env.test?) ? :render! : :render
    end
    
    ActiveSupport.run_load_hooks(:view_component_liquid, self)
  end
end

