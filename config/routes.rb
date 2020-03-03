Rails.application.routes.draw do
  devise_for :users
  resources :entries, only: [:index, :create, :update, :destroy] do
    collection do
      post :update_all
    end
  end
  resources :invoices, only: [:index, :show, :create, :edit, :update, :destroy]
  resources :projects, only: [:index, :create, :edit, :update, :destroy] do
    member do
      post :import
      put :upload
    end
  end
  root to: "home#show"
end
