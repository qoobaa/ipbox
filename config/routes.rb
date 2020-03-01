Rails.application.routes.draw do
  resources :entries, only: [:index, :create, :update, :destroy] do
    collection do
      post :update_all
    end
  end
  resources :invoices, only: [:index, :show, :new, :create, :edit, :update]
  resources :projects, only: [:index, :new, :create, :edit] do
    member do
      post :import
      put :upload
    end
  end
  root to: "entries#index"
end
