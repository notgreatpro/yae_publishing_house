# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")

# Add ActiveAdmin assets path
activeadmin_path = Gem.loaded_specs['activeadmin'].full_gem_path
Rails.application.config.assets.paths << "#{activeadmin_path}/app/assets/stylesheets"
Rails.application.config.assets.paths << "#{activeadmin_path}/app/assets/javascripts"
Rails.application.config.assets.paths << "#{activeadmin_path}/vendor/assets/javascripts"

# Precompile additional assets.
Rails.application.config.assets.precompile += %w( active_admin.css active_admin.js )