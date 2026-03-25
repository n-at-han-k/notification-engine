# frozen_string_literal: true

require "noticed"
require "ui"

module NotificationEngine
  class Engine < ::Rails::Engine
    isolate_namespace NotificationEngine

    # Register importmap pins for Stimulus controllers
    initializer "notification_engine.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << Engine.root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << Engine.root.join("app/javascript")
      end
    end

    # Add engine assets to the asset load path (for propshaft/sprockets)
    initializer "notification_engine.assets" do |app|
      app.config.assets.paths << Engine.root.join("app/assets/javascripts")
      app.config.assets.paths << Engine.root.join("app/assets/stylesheets")

      # rails-active-ui ships stylesheets.css directly in app/assets/
      app.config.assets.paths << Ui::Engine.root.join("app/assets")
    end

    # Make engine helpers available in host app views
    initializer "notification_engine.helpers" do
      ActiveSupport.on_load(:action_view) do
        include NotificationEngine::ApplicationHelper
      end
    end
  end
end
