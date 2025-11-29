require_relative "boot"
require "rails/all"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module YaePublishingHouse
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    
    # Add ActiveAdmin asset paths
    config.assets.paths << Gem.loaded_specs['activeadmin'].full_gem_path + '/app/assets/stylesheets'
    config.assets.paths << Gem.loaded_specs['activeadmin'].full_gem_path + '/app/assets/javascripts'
    config.assets.paths << Gem.loaded_specs['activeadmin'].full_gem_path + '/vendor/assets/javascripts'
  end
end