# frozen_string_literal: true

require "test_helper"

class NotificationEngine::HelpersTest < NotificationEngine::HelperTest
  def test_unread_notification_count_with_no_notifications
    assert_equal 0, unread_notification_count
  end

  def test_unread_notification_count_with_notifications
    event = Noticed::Event.create!(type: "Noticed::Event", params: {})
    Noticed::Notification.create!(type: "Noticed::Notification", event: event, recipient: @user)
    Noticed::Notification.create!(type: "Noticed::Notification", event: event, recipient: @user, read_at: Time.current)

    assert_equal 1, unread_notification_count
  end

  def test_unread_notification_count_with_nil_user
    @user = nil
    assert_equal 0, unread_notification_count
  end

  def test_notification_bell_renders_link
    html = notification_bell
    assert_includes html, "notification-bell"
    assert_includes html, "Notifications"
  end

  def test_notification_bell_shows_badge_when_unread
    event = Noticed::Event.create!(type: "Noticed::Event", params: {})
    Noticed::Notification.create!(type: "Noticed::Notification", event: event, recipient: @user)

    html = notification_bell
    assert_includes html, "notification-badge"
    assert_includes html, ">1<"
  end

  def test_notification_bell_no_badge_when_all_read
    event = Noticed::Event.create!(type: "Noticed::Event", params: {})
    Noticed::Notification.create!(type: "Noticed::Notification", event: event, recipient: @user, read_at: Time.current)

    html = notification_bell
    refute_includes html, "notification-badge"
  end

  def test_notification_bell_returns_nil_with_no_user
    @user = nil
    assert_nil notification_bell
  end

  def test_notification_bell_accepts_custom_class
    html = notification_bell(class: "my-custom-bell")
    assert_includes html, "notification-bell my-custom-bell"
  end

  def test_active_filter_class_returns_active_for_match
    @params = ActionController::Parameters.new(filter: "unread")
    assert_equal "active", active_filter_class("unread")
  end

  def test_active_filter_class_returns_empty_for_mismatch
    @params = ActionController::Parameters.new(filter: "unread")
    assert_equal "", active_filter_class("read")
  end

  def test_active_filter_class_returns_active_for_nil_when_no_filter
    @params = ActionController::Parameters.new({})
    assert_equal "active", active_filter_class(nil)
  end

  private

  def params
    @params || ActionController::Parameters.new({})
  end
end
