# frozen_string_literal: true

# Hook into ActiveView's template handling system
module ViewComponentLiquid
  class TemplateHandler
    YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze

    class << self
      def call(template, source)
        "ViewComponentLiquid::TemplateHandler.new(self).render(#{source.inspect}, local_assigns)"
      end

      def strip_front_matter(markup)
        if has_yaml_header?(markup)
          begin
            $POSTMATCH if markup =~ YAML_FRONT_MATTER_REGEXP
          rescue StandardError => e
            Rails.logger.warn "Error stripping front matter from Liquid: #{e.message}"
            ""
          end
        else
          markup
        end
      end
      
      def has_yaml_header?(markup)
        markup.lines.first.match? %r!\A---\s*\r?\n!
      end
    end

    def initialize(view)
      @view = view
      @controller = @view.controller
    end

    def render(template, local_assigns={})
      template = self.class.strip_front_matter(template)

      assigns = local_assigns.stringify_keys
      assigns["controller"] = {
        "controller_name" => @controller.controller_name,
        "action_name" => @controller.action_name
      }
      if @view.respond_to?(:assigns)
        assigns["controller"].merge! @view.assigns.to_h
      end

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

