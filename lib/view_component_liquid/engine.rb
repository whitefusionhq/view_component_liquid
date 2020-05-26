# frozen_string_literal: true

require "rails"
require "view_component_liquid"

module ViewComponentLiquid
  class Engine < Rails::Engine
    initializer "view_component_liquid.add_liquid_template_handler" do
      ActiveSupport.on_load(:action_view) do
        ActionView::Template.register_template_handler(:liquid, ViewComponentLiquid::TemplateHandler)
      end
    end
  end
end

