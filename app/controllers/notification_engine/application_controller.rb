# frozen_string_literal: true

module NotificationEngine
  class ApplicationController < ActionController::Base
    private

    def notification_engine_current_user
      method = NotificationEngine.current_user_method
      main_app_controller = request.env["action_controller.instance"]

      if main_app_controller&.respond_to?(method, true)
        main_app_controller.send(method)
      elsif respond_to?(method, true)
        send(method)
      end
    end

    def notifications_scope
      notification_engine_current_user.notifications.newest_first
    end
  end
end
