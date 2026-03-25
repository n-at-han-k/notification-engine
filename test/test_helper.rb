# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"

# Boot a minimal Rails app with ActiveRecord so the engine can mount and we can
# exercise controllers, helpers, and the noticed integration end-to-end.
ENV["RAILS_ENV"] = "test"
ENV["DATABASE_URL"] ||= "postgresql://postgres@localhost/notification_engine_test"

require "rails/all"

# Dummy Rails app
class DummyApp < Rails::Application
  config.eager_load = false
  config.hosts.clear
  config.secret_key_base = "test-secret-key-base-that-is-long-enough"
  config.active_support.deprecation = :stderr
  config.action_cable.cable = { "adapter" => "async" }

  # Stub assets config so engine asset initializers don't blow up
  config.assets = ActiveSupport::OrderedOptions.new
  config.assets.paths = []
  config.assets.precompile = []

  # Importmap stub
  config.importmap = ActiveSupport::OrderedOptions.new
  config.importmap.paths = []
  config.importmap.cache_sweepers = []
end

require "turbo-rails"
require "notification_engine"

DummyApp.initialize!

# Register turbo_stream MIME type (turbo-rails railtie needs ActionCable, so we just register the type)
Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream

# Routes for the dummy app (draw after initialize so engine route proxy is available)
Rails.application.routes.draw do
  root to: ->(_env) { [200, { "content-type" => "text/plain" }, ["OK"]] }
  mount NotificationEngine::Engine, at: "/", as: "notification_engine"
end

# --- Database schema ---

ActiveRecord::Schema.define do
  suppress_messages do
    create_table :users, force: true do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :noticed_events, force: true do |t|
      t.string :type
      t.belongs_to :record, polymorphic: true
      t.jsonb :params
      t.integer :notifications_count, default: 0
      t.timestamps
    end

    create_table :noticed_notifications, force: true do |t|
      t.string :type
      t.belongs_to :event, null: false
      t.belongs_to :recipient, polymorphic: true, null: false
      t.datetime :read_at
      t.datetime :seen_at
      t.timestamps
    end
  end
end

# --- Models ---

class User < ActiveRecord::Base
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"
end

# Fake current_user for tests
class ::ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.first_or_create!(name: "Test User")
  end
  helper_method :current_user
end

# --- Test base classes ---

class NotificationEngine::IntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.first_or_create!(name: "Test User")
  end

  def teardown
    Noticed::Notification.delete_all
    Noticed::Event.delete_all
  end

  # Create a notification for the test user
  def create_notification(read: false)
    event = Noticed::Event.create!(type: "Noticed::Event", params: { message: "Test notification" })
    Noticed::Notification.create!(
      type: "Noticed::Notification",
      event: event,
      recipient: @user,
      read_at: read ? Time.current : nil
    )
  end

  def engine_routes
    NotificationEngine::Engine.routes.url_helpers
  end
end

class NotificationEngine::HelperTest < ActionView::TestCase
  include NotificationEngine::ApplicationHelper
  include NotificationEngine::Engine.routes.url_helpers

  def setup
    @user = User.first_or_create!(name: "Test User")
    Noticed::Notification.delete_all
    Noticed::Event.delete_all
  end

  def current_user
    @user
  end

  def notification_engine
    NotificationEngine::Engine.routes.url_helpers
  end
end
