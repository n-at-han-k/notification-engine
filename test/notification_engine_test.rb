# frozen_string_literal: true

require "test_helper"

class NotificationEngineTest < Minitest::Test
  def test_version
    refute_nil NotificationEngine::VERSION
  end

  def test_current_user_method_default
    assert_equal :current_user, NotificationEngine.current_user_method
  end

  def test_parent_controller_default
    assert_equal "ApplicationController", NotificationEngine.parent_controller
  end
end
