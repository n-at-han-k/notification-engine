# frozen_string_literal: true

module NotificationEngine
  class ApplicationController < ActionController::Base
    private

    def current_user
      send(NotificationEngine.current_user_method)
    end

    def notifications_scope
      current_user.notifications.newest_first
    end
  end
end
