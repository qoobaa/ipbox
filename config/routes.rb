Rails.application.routes.draw do
  devise_for :users
  resources :entries, only: [:index, :create, :update, :destroy] do
    collection do
      post :update_all
      delete :destroy_all
    end
  end
  resources :invoices, only: [:index, :show, :create, :edit, :update, :destroy]
  resources :projects, only: [:index, :create, :edit, :update, :destroy] do
    member do
      post :import
      put :upload
    end
  end
  get :tos, to: "home#tos"

  authenticated :user do
    root to: "entries#index", as: :authenticated_root
  end

  root to: "home#show"
end
