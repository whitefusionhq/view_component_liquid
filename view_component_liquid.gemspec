require_relative "lib/view_component_liquid/version"

Gem::Specification.new do |spec|
  spec.name          = "view_component_liquid"
  spec.version       = ViewComponentLiquid::VERSION
  spec.authors       = ["Jared White"]
  spec.email         = ["jared@whitefusion.io"]

  spec.summary       = %q{Use Liquid templates and components from within ViewComponent}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/bridgetownrb/view_component_liquid"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "liquid",            "~> 4.0"
  spec.add_runtime_dependency "liquid-render-tag", "~> 0.2"
  spec.add_runtime_dependency "activesupport",     [">= 5.0.0", "< 7.0"]
  
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.0"
end
