# frozen_string_literal: true

NotificationEngine::Engine.routes.draw do
  resources :notifications, only: %i[index destroy] do
    member do
      patch :mark_as_read
      patch :mark_as_unread
    end

    collection do
      post :mark_all_read
    end
  end
end
