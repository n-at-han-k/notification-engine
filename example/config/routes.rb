Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  mount NotificationEngine::Engine, at: "/"
end
