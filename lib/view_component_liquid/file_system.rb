# frozen_string_literal: true

# Provide Liquid views/partials/components to the template handler and render tag
module ViewComponentLiquid
  class FileSystem
    def initialize(view)
      @view = view
    end

    def read_template_file(template_path)
      controller_path = view.controller_path

      template_name = File.basename(template_path)
      template_folders = unless template_path.include?("/")
                           [
                             "",
                             controller_path,
                             "application",
                             "shared"
                           ]
                         else
                          [File.dirname(template_path)]
                         end

      # Search Rails' configured view paths first
      result = view.view_paths.find_all(
        template_name,
        template_folders,
        true,
        lookup_details
      )

      if result.present?
        TemplateHandler.strip_front_matter(result.first.source)
      else
        # Time to look through autoload paths for component folders
        components_folders = Zeitwerk::Loader.all_dirs.select {|item| item.ends_with?("_components")}

        template = nil

        components_folders.each do |components_folder|
          tmpl = components_folder + "/#{template_path}.liquid"
          if File.exist?(tmpl)
            template = TemplateHandler.strip_front_matter(File.read(tmpl))
            break
          end
        end

        template.presence || raise(ActionView::MissingTemplate.new(template_folders + components_folders, template_name, template_folders, false, "liquid views"))
      end
    end

    private

    attr_reader :view

    def lookup_details
      {
        locale:   [view.locale, :en],
        formats:  view.formats,
        variants: [],
        handlers: [:liquid],
        versions: []
      }
    end
  end
end
