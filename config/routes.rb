Rails.application.routes.draw do
  resources :entries, only: [:index, :create, :update]
  resources :invoices, only: [:index, :new, :create, :edit, :update]
  resources :repositories, only: [:index, :new, :create] do
    member do
      get :import
      post :import
    end
  end
  root to: "entries#index"
end
