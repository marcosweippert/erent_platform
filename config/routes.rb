Rails.application.routes.draw do
  resources :users, except: %i[show destroy]
  resource :session, only: %i[new create destroy]
  resource :password_change, only: %i[edit update]
  resource :forgot_password, only: %i[new create]

  resources :contract_amendments
  get 'contracts/new'
  get 'contracts/edit'
  get 'home/index'
  get 'properties/index'
  get 'properties/show'
  get 'properties/new'
  get 'properties/edit'
  root "home#index"

  get 'contracts/load_property_data', to: 'contracts#load_property_data'
  get 'contracts/calculate_dates', to: 'contracts#calculate_dates'

  get 'people/address_lookup', to: 'people#address_lookup'
  
  resources :people do
    post :upload_files, on: :member
  end

  delete '/attachments/:id', to: 'attachments#destroy', as: :attachment
  
  get 'properties/address_lookup', to: 'properties#address_lookup'
  get 'properties/generate_reference', to: 'properties#generate_reference'
  resources :properties do
    collection do
      get :reserved
    end
  end

  resources :contracts do
    resources :inspections, only: %i[new create show] do
      member do
        get :pdf, defaults: { format: :pdf }
      end
    end

    member do
      patch :finalize
      get :contract_pdf, defaults: { format: :pdf }
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
