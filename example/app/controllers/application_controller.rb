class ApplicationController < ActionController::Base
  # Fake current_user for the example app — returns the first User.
  # In a real app this comes from Devise, Warden, etc.
  def current_user
    @current_user ||= User.first
  end
  helper_method :current_user
end
