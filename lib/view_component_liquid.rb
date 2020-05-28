# frozen_string_literal: true

require "action_view"
require "active_support/dependencies/autoload"
require "active_support/concern"
require "liquid"
require "liquid-render-tag"
require "liquid-component"

module ViewComponentLiquid
  extend ActiveSupport::Autoload

  autoload :TemplateHandler
  autoload :FileSystem
end

# Mixin to let ViewComponent work with Liquid
module ViewComponent
  module Liquify
    extend ActiveSupport::Concern

    included do
      class_attribute :liquid_keys
    end  
    
    class_methods do
      def liquid_accessor(*varnames)
        self.liquid_keys ||= Set.new
        varnames.each do |varname|
          self.liquid_keys << varname
          attr_accessor varname
        end
      end
      
      private
  
      # Look for both compname.liquid and compname_component.liquid
      def matching_views_in_source_location
        location_without_extension = source_location.chomp(File.extname(source_location)).split("/").tap do |pathname|
          pathname.last.delete_suffix! "_component"
        end.join("/")
        Dir["#{location_without_extension}.liquid", "#{location_without_extension}_component.liquid"]
      end
    end
    
    def local_assigns
      {}.yield_self do |assigns|
        self.class.liquid_keys.each do |key|
          assigns[key] = send(key)
        end
        assigns
      end
    end
  end
end

