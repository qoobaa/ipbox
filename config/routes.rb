Rails.application.routes.draw do
  resources :logs, only: [:index, :create, :update]
  root to: "logs#index"
end
