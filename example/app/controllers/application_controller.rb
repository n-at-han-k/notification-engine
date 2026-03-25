class ApplicationController < ActionController::Base
  # Fake current_user for the example app — returns the first User,
  # creating one if none exists.
  # In a real app this comes from Devise, Warden, etc.
  def current_user
    @current_user ||= User.first_or_create!(name: "Demo User")
  end
  helper_method :current_user
end
