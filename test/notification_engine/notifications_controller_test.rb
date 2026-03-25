# frozen_string_literal: true

require "test_helper"

class NotificationEngine::NotificationsControllerTest < NotificationEngine::IntegrationTest
  def test_index_renders_with_no_notifications
    get engine_routes.notifications_path
    assert_response :success
    assert_select ".ui.placeholder.segment"
  end

  def test_index_renders_notifications
    create_notification
    create_notification

    get engine_routes.notifications_path
    assert_response :success
    assert_select "#notifications turbo-frame", 2
  end

  def test_index_filters_unread
    create_notification(read: false)
    create_notification(read: true)

    get engine_routes.notifications_path(filter: "unread")
    assert_response :success
    assert_select "#notifications turbo-frame", 1
    assert_select "#notifications .ui.blue.segment", 1
  end

  def test_index_filters_read
    create_notification(read: false)
    create_notification(read: true)

    get engine_routes.notifications_path(filter: "read")
    assert_response :success
    assert_select "#notifications turbo-frame", 1
    assert_select "#notifications .ui.secondary.segment", 1
  end

  def test_mark_as_read
    notification = create_notification(read: false)

    patch engine_routes.mark_as_read_notification_path(notification)
    assert_response :redirect

    notification.reload
    assert notification.read?
  end

  def test_mark_as_read_turbo_stream
    notification = create_notification(read: false)

    patch engine_routes.mark_as_read_notification_path(notification),
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success

    notification.reload
    assert notification.read?
  end

  def test_mark_as_unread
    notification = create_notification(read: true)

    patch engine_routes.mark_as_unread_notification_path(notification)
    assert_response :redirect

    notification.reload
    assert notification.unread?
  end

  def test_mark_as_unread_turbo_stream
    notification = create_notification(read: true)

    patch engine_routes.mark_as_unread_notification_path(notification),
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success

    notification.reload
    assert notification.unread?
  end

  def test_mark_all_read
    create_notification(read: false)
    create_notification(read: false)
    create_notification(read: true)

    post engine_routes.mark_all_read_notifications_path
    assert_response :redirect

    assert_equal 0, @user.notifications.unread.count
  end

  def test_destroy
    notification = create_notification

    assert_difference -> { Noticed::Notification.count }, -1 do
      delete engine_routes.notification_path(notification)
    end

    assert_response :redirect
  end

  def test_destroy_turbo_stream
    notification = create_notification

    assert_difference -> { Noticed::Notification.count }, -1 do
      delete engine_routes.notification_path(notification),
             headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end

    assert_response :success
  end

  def test_index_with_no_user
    # Simulate no user by making current_user return nil
    User.delete_all

    ::ApplicationController.define_method(:current_user) { nil }

    get engine_routes.notifications_path
    assert_response :success
    assert_select ".ui.placeholder.segment"
  ensure
    ::ApplicationController.define_method(:current_user) do
      @current_user ||= User.first_or_create!(name: "Test User")
    end
  end
end
