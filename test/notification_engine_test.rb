# frozen_string_literal: true

require "test_helper"

class NotificationEngineTest < Minitest::Test
  def test_version
    refute_nil NotificationEngine::VERSION
  end
end
