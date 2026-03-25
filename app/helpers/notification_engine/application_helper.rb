# frozen_string_literal: true

module NotificationEngine
  module ApplicationHelper
    # Renders a notification bell link with an unread count badge.
    #
    #   <%= notification_bell %>
    #   <%= notification_bell(class: "my-bell") %>
    #
    def notification_bell(**options)
      user = notification_engine_current_user
      return unless user

      count = user.notifications.unread.count
      path  = notification_engine.notifications_path

      css = ["notification-bell", options.delete(:class)].compact.join(" ")

      tag.a(href: path, class: css, **options) do
        safe_join([
          tag.span("Notifications", class: "notification-bell-label"),
          (tag.span(count, class: "ui mini circular blue label notification-badge") if count > 0)
        ].compact)
      end
    end

    # Returns the unread notification count for the current user.
    def unread_notification_count
      user = notification_engine_current_user
      return 0 unless user

      user.notifications.unread.count
    end

    # Returns a CSS class name for the active filter tab.
    def active_filter_class(filter)
      current = params[:filter].presence
      current == filter ? "active" : ""
    end

    private

    def notification_engine_current_user
      method = NotificationEngine.current_user_method
      return nil unless respond_to?(method, true)

      send(method)
    end
  end
end
