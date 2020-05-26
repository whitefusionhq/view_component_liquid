# ViewComponentLiquid

Use Liquid templates and components from within GitHub's [ViewComponent](https://github.com/github/view_component) and your Rails application.


TODO: Update docs below

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'view_component_liquid'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install view_component_liquid


Next, add this line below where you require `view_component` in `config/application.rb`:

```ruby
require "view_component_liquid/engine"
```

## Usage

TODO: Write usage instructions here

## Bridgetown Filters

    $ bundle add bridgetown-core

Then create the file `config/initializers/bridgetown.rb`

```ruby
require "bridgetown-core/filters"
Liquid::Template.register_filter Bridgetown::Filters
```

## Loading shared components from a Bridgetown site

Example:

```ruby
# config/initializers/bridgetown.rb

# Set the path to your Bridgetown folder relative to the Rails root
bridgetown_path = Rails.root.parent.join("bridgetown-site-repo")

# Load in Liquid components and any shared Bridgetown builders
components_path = bridgetown_path.join("src", "_components")
plugins_path = bridgetown_path.join("plugins", "shared_rails")  
ActiveSupport::Dependencies.autoload_paths << components_path
ActiveSupport::Dependencies.autoload_paths << plugins_path

# Instantiate any shared builders
ActiveSupport.on_load(:action_controller) do
  class SiteBuilder < Bridgetown::Builder; end

  # Pass along a "fake" site object. If you'd to include config to pass to
  # your builder, you can do t
  TagsBuilder.new(
    "TagsBuilder",
    OpenStruct.new(config: {
      rails: "included config!"
    }.with_indifferent_access)
  )
end
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/view_component_liquid/view_component_liquid.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the View::Component::Liquid project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bridgetownrb/view_component_liquid/blob/master/CODE_OF_CONDUCT.md).
