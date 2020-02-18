Rails.application.routes.draw do
  resources :entries, only: [:index, :create, :update]
  resources :invoices, only: [:index, :new, :create, :edit, :update]
  root to: "entries#index"
end
