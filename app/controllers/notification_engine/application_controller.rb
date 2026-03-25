# frozen_string_literal: true

module NotificationEngine
  class ApplicationController < ::ApplicationController
    private

    def notification_engine_current_user
      method = NotificationEngine.current_user_method
      return nil unless respond_to?(method, true)

      send(method)
    end

    def notifications_scope
      user = notification_engine_current_user
      return Noticed::Notification.none unless user

      user.notifications.newest_first
    end
  end
end
