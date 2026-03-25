# frozen_string_literal: true

require_relative "lib/notification_engine/version"

Gem::Specification.new do |spec|
  spec.name        = "notification_engine"
  spec.version     = NotificationEngine::VERSION
  spec.authors     = ["Nathan Kidd"]
  spec.email       = ["nathankidd@hey.com"]
  spec.homepage    = "https://github.com/n-at-han-k/notification-engine"
  spec.summary     = "Rails engine for in-app notifications"
  spec.description = "Provides an in-app notification system as a Rails engine " \
                     "with Stimulus controllers, importmap integration, and rails-active-ui components."
  spec.license     = "Apache-2.0"

  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "rails",           ">= 8.1"
  spec.add_dependency "importmap-rails"
  spec.add_dependency "stimulus-rails"
  spec.add_dependency "rails-active-ui"
end
