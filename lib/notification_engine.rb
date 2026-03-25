# frozen_string_literal: true

require "notification_engine/version"
require "notification_engine/engine"

module NotificationEngine
  # Host app sets this to the method name used to get the current user.
  # Defaults to :current_user (standard Rails/Devise convention).
  mattr_accessor :current_user_method, default: :current_user
end
